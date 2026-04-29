#!/bin/sh
# Entrypoint for the docfx preview container.
#
# 1. Run an initial docfx build into /site.
# 2. Write a tiny redirect index.html so http://localhost:8080/ lands on
#    a real article page instead of the bare TOC frame.
# 3. Inject a small livereload script into every built HTML page that
#    polls /__build-id.txt and reloads the tab when the build id changes.
# 4. Start `docfx serve` in the background so the static site is served.
# 5. Watch /repo/docs for .md / .yml / .yaml changes via inotifywait and
#    rebuild the site so the served output stays in sync with edits.
#    On native Linux/WSL2 ext4 mounts inotify events are reliable; on
#    Windows-host (drvfs/9p) bind mounts they are not, so we fall back
#    to mtime polling automatically if inotifywait fails to start or
#    appears to deliver no events for the first edit. A fingerprint
#    check still gates each rebuild so spurious events (timestamp-only
#    touches, editor swap files) don't trigger redundant builds.
#
# PREVIEW_SCOPE
# -------------
# docfx 2.x has no working incremental build (the `--incremental` flag
# was removed in 2.59 and is rejected outright in 2.78.3 -- every build
# re-templates all 7138 docs in this repo, taking ~90s). To make the
# edit/preview loop fast, set PREVIEW_SCOPE to a top-level docs subtree
# like "user-guide" or "pipelines". The container then builds only that
# subtree (~5-15s) plus the breadcrumb. Cross-section links into
# unscoped subtrees will 404 in the preview -- unset PREVIEW_SCOPE (or
# leave it blank) for a full-fidelity build.

set -eu

DOCS_DIR=/repo/docs
SITE_DIR=/site
LOG_FILE=$SITE_DIR/docfx.log
LANDING=/team-services/all/user-guide/what-is-azure-devops.html
# How often the polling fallback fingerprints the docs tree. Only used
# when inotifywait is unavailable. Lower = faster detection at the cost
# of CPU; on native ext4 the find walk is ~50ms so 0.2s is cheap.
POLL_INTERVAL=${PREVIEW_POLL_INTERVAL:-0.2}
# How long the watcher waits after the first change event before kicking
# off the rebuild, so a flurry of saves coalesces into one build. The
# inotify path uses this to drain its event queue; the polling fallback
# uses it the same way. Default 0.3s -- VS Code's atomic-save fires
# multiple events within ~50ms so any value above ~0.1s is sufficient.
DEBOUNCE_INTERVAL=${PREVIEW_DEBOUNCE_INTERVAL:-0.3}
PREVIEW_SCOPE=${PREVIEW_SCOPE:-}

# Path to the docfx config to use for builds. We ALWAYS build from a
# generated config in /tmp rather than the repo's real docs/docfx.json,
# because the real config sets `"template": []` which causes docfx to
# emit no HTML for Conceptual or Toc document types (you'll see
# "no template processing document type(s): Conceptual,Toc" in the log
# and zero .html files in /site). The generated copy patches the
# template list to ["default", "modern"] so docfx actually applies
# Conceptual templates. docfx 2.x resolves globs relative to the config
# file's directory (not cwd), and /repo is bind-mounted read-only, so
# the generated config lives next to a symlink farm at $BUILD_DIR that
# mirrors /repo/docs entry-by-entry.
BUILD_DIR=/tmp/preview-build
BUILD_CONFIG="$BUILD_DIR/docfx.json"
BUILD_CWD="$BUILD_DIR"

# Marker the injector greps for, so we never inject twice into the same
# HTML file (modern template's --serve rewrites can otherwise duplicate).
LR_MARKER='<!--docfx-livereload-->'

# Generate /tmp/preview-docfx.json from the real docfx.json, restricting
# the "all" content + resource groups to PREVIEW_SCOPE. Other groups
# (the breadcrumb single-file group, the legacy bootstrap group) are
# left intact so the breadcrumb and landing page still build.
write_scoped_config() {
    SCOPE=$1
    # Build a symlink farm so docfx can resolve globs against /repo/docs
    # while reading our generated config from a writable location.
    mkdir -p "$BUILD_DIR"
    # Clear any stale symlinks/files (but keep the directory itself).
    find "$BUILD_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
    for entry in "$DOCS_DIR"/*; do
        name=$(basename "$entry")
        [ "$name" = "docfx.json" ] && continue
        ln -sfn "$entry" "$BUILD_DIR/$name"
    done
    jq --arg scope "$SCOPE" '
        .build.template = ["default", "modern"]
        | .build.content |= map(
            if .group == "all" then
                .files = [
                    ($scope + "/**/*.md"),
                    ($scope + "/**/*.yml"),
                    "user-guide/what-is-azure-devops.md",
                    "index.yml",
                    "toc.yml"
                ]
            else . end
        )
        | .build.resource |= map(
            if .group == "all" then
                .files = [
                    ($scope + "/**/*.png"),
                    ($scope + "/**/*.jpg"),
                    ($scope + "/**/*.gif"),
                    ($scope + "/**/*.svg"),
                    ($scope + "/**/*.mp4")
                ]
            else . end
        )
    ' "$DOCS_DIR/docfx.json" > "$BUILD_CONFIG"
    echo "[entrypoint] wrote scoped config $BUILD_CONFIG (scope=$SCOPE)"
}

# Generate $BUILD_CONFIG with the same content/resource groups as the
# real docfx.json, but with the template list populated so docfx emits
# Conceptual HTML (the real config has `"template": []` which suppresses
# all article output when using `docfx serve` for preview).
write_full_config() {
    mkdir -p "$BUILD_DIR"
    find "$BUILD_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
    for entry in "$DOCS_DIR"/*; do
        name=$(basename "$entry")
        [ "$name" = "docfx.json" ] && continue
        ln -sfn "$entry" "$BUILD_DIR/$name"
    done
    jq '.build.template = ["default", "modern"]' \
        "$DOCS_DIR/docfx.json" > "$BUILD_CONFIG"
    echo "[entrypoint] wrote full-build config $BUILD_CONFIG (template=default,modern)"
}

# Inject the livereload <script> into every HTML file under /site that
# does not already have it, then write the build-id file. The script
# polls /__build-id.txt every 1.2s and reloads on change. It also
# polls on focus/visibility-change/pageshow so background tabs that
# were throttled by the browser still pick up the latest build the
# moment they become visible again.
inject_livereload() {
    BUILD_ID=$(date +%s%N)
    echo "$BUILD_ID" > "$SITE_DIR/__build-id.txt"

    SNIPPET="$LR_MARKER<script>(function(){var c=null;function p(){fetch('/__build-id.txt',{cache:'no-store'}).then(function(r){return r.text()}).then(function(id){id=(''+id).trim();if(c===null){c=id}else if(id!==c){location.reload()}}).catch(function(){})}setInterval(p,1200);p();document.addEventListener('visibilitychange',function(){if(!document.hidden)p()});window.addEventListener('focus',p);window.addEventListener('pageshow',p)})();</script>"

    find "$SITE_DIR" -type f -name '*.html' -print 2>/dev/null | while IFS= read -r f; do
        if ! grep -q "$LR_MARKER" "$f" 2>/dev/null; then
            if grep -q '</body>' "$f"; then
                awk -v s="$SNIPPET" '
                    {
                        if (!done && index($0, "</body>") > 0) {
                            sub("</body>", s "</body>")
                            done = 1
                        }
                        print
                    }
                ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
            else
                printf '\n%s\n' "$SNIPPET" >> "$f"
            fi
        fi
    done
}

build() {
    # docfx 2.x has NO working incremental mode. Every build re-templates
    # every doc in scope. Speed comes from narrowing scope, not flags.
    # Confirmed-working docfx 2.78.3 flags:
    #   --output --log --template (repeatable) --serve --hostname --port
    #
    # Historical note: previous versions of this script wiped
    # $SITE_DIR/team-services and $BUILD_CWD/obj before every build,
    # because under Windows-host bind mounts (drvfs/9p) docfx 2.78.3's
    # persistent manifest at $SITE_DIR/<dest>/manifest.json saw stale
    # mtimes and silently skipped re-emitting HTML. On native
    # Linux/WSL2 ext4 mtimes are reliable and docfx's manifest-based
    # skip-unchanged logic works correctly, so we no longer wipe --
    # this lets docfx skip the disk write for unchanged HTML on each
    # rebuild. If you ever see the served page failing to update after
    # an edit, set PREVIEW_FORCE_CLEAN=1 to restore the old wipe
    # behavior, or restart the container.
    #
    # We do NOT pass --template here -- the build.template list is set
    # in the generated $BUILD_CONFIG so docfx actually applies Conceptual
    # processors. The real docs/docfx.json has `"template": []` which
    # overrides any CLI --template flag and produces zero HTML.
    if [ "${PREVIEW_FORCE_CLEAN:-0}" = "1" ]; then
        rm -rf "$SITE_DIR/team-services" 2>/dev/null || true
        rm -rf "$BUILD_CWD/obj" 2>/dev/null || true
    fi
    ( cd "$BUILD_CWD" && docfx build "$BUILD_CONFIG" \
        --output "$SITE_DIR" \
        --log "$LOG_FILE" ) \
        || echo "[entrypoint] docfx build returned non-zero (continuing)"

    printf '%s' "<!doctype html><meta charset=\"utf-8\"><title>Azure DevOps docs preview</title><meta http-equiv=\"refresh\" content=\"0; url=$LANDING\"><link rel=\"canonical\" href=\"$LANDING\"><p>Redirecting to <a href=\"$LANDING\">the Azure DevOps overview</a>.</p>" \
        > "$SITE_DIR/index.html"

    inject_livereload
}

# When PREVIEW_SCOPE is set, only watch that subtree.
fingerprint() {
    if [ -n "$PREVIEW_SCOPE" ] && [ -d "$DOCS_DIR/$PREVIEW_SCOPE" ]; then
        WATCH_DIR="$DOCS_DIR/$PREVIEW_SCOPE"
    else
        WATCH_DIR="$DOCS_DIR"
    fi
    find "$WATCH_DIR" \
        -type d \( -name obj -o -name _data -o -name _shared -o -name includes -o -name .git \) -prune \
        -o -type f \( -name '*.md' -o -name '*.yml' -o -name '*.yaml' \) -printf '%p %T@ %s\n' \
        | sort \
        | sha1sum \
        | awk '{print $1}'
}

cd "$DOCS_DIR"

if [ -n "$PREVIEW_SCOPE" ]; then
    if [ ! -d "$DOCS_DIR/$PREVIEW_SCOPE" ]; then
        echo "[entrypoint] WARNING: PREVIEW_SCOPE='$PREVIEW_SCOPE' is not a directory under $DOCS_DIR. Falling back to full build."
        PREVIEW_SCOPE=""
        write_full_config
    else
        echo "[entrypoint] PREVIEW_SCOPE=$PREVIEW_SCOPE -- builds will be scoped to docs/$PREVIEW_SCOPE/"
        write_scoped_config "$PREVIEW_SCOPE"
    fi
else
    write_full_config
fi

echo "[entrypoint] initial docfx build (config=$BUILD_CONFIG)..."
build
echo "[entrypoint] initial build done (build-id $(cat $SITE_DIR/__build-id.txt))."

echo "[entrypoint] starting preview HTTP server on 0.0.0.0:8080 (Cache-Control: no-store)..."
# Serve via Python's http.server with no-cache headers, instead of
# `docfx serve`. docfx serve emits ETag/Last-Modified but no
# Cache-Control, so a client tab that received an old livereload
# script can hold onto a stale rendered DOM and never re-fetch the
# page. With no-store, every reload (including the auto-reload fired
# by the injected livereload script) gets fresh HTML, fresh JS, and
# the latest livereload snippet -- which guarantees that subsequent
# rebuilds reload the tab even if it was backgrounded across a
# container rebuild.
(
    cd "$SITE_DIR"
    exec python3 -u -c '
import http.server, socketserver
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()
    def log_message(self, fmt, *a): pass
socketserver.TCPServer.allow_reuse_address = True
with socketserver.ThreadingTCPServer(("0.0.0.0", 8080), H) as s:
    s.serve_forever()
'
) &
SERVE_PID=$!

trap 'echo "[entrypoint] shutting down..."; kill $SERVE_PID 2>/dev/null || true; exit 0' TERM INT

# Watch directory: $DOCS_DIR or the scoped subtree.
if [ -n "$PREVIEW_SCOPE" ] && [ -d "$DOCS_DIR/$PREVIEW_SCOPE" ]; then
    WATCH_DIR="$DOCS_DIR/$PREVIEW_SCOPE"
else
    WATCH_DIR="$DOCS_DIR"
fi
LAST=$(fingerprint)

# Polling fallback (also used as the rebuild trigger inside the inotify
# loop, gated by a fingerprint check so spurious events don't rebuild).
polling_loop() {
    echo "[entrypoint] polling $WATCH_DIR every ${POLL_INTERVAL}s (debounce ${DEBOUNCE_INTERVAL}s) for changes..."
    while true; do
        sleep "$POLL_INTERVAL"
        CURRENT=$(fingerprint)
        if [ "$CURRENT" != "$LAST" ]; then
            sleep "$DEBOUNCE_INTERVAL"
            CURRENT=$(fingerprint)
            echo "[entrypoint] $(date +%H:%M:%S) change detected -- rebuilding..."
            T0=$(date +%s)
            build
            T1=$(date +%s)
            echo "[entrypoint] $(date +%H:%M:%S) rebuild done in $((T1-T0))s (build-id $(cat $SITE_DIR/__build-id.txt)) -- browser will auto-reload."
            LAST=$CURRENT
        fi
    done
}

# inotify-based watcher: emits one event per filesystem change. Bursts
# (VS Code atomic save = several events in <100ms) are coalesced by
# sleeping DEBOUNCE_INTERVAL after the first event, then re-fingerprinting
# to ensure something actually changed before triggering a rebuild.
inotify_loop() {
    if ! command -v inotifywait >/dev/null 2>&1; then
        echo "[entrypoint] inotifywait not found -- falling back to polling."
        polling_loop
        return
    fi
    echo "[entrypoint] watching $WATCH_DIR via inotify (debounce ${DEBOUNCE_INTERVAL}s) for changes..."
    # Run inotifywait in a pipeline. -m: monitor; -r: recursive; -q: quiet;
    # filter to docs source files (.md/.yml/.yaml) via --include. Note:
    # inotifywait 3.22 rejects --include + --exclude together, and we
    # don't need --exclude here because $WATCH_DIR is /repo/docs which
    # doesn't contain obj/ or .git/. Editor swap-file noise is filtered
    # by the extension regex.
    inotifywait -m -r -q \
        -e modify -e create -e delete -e moved_to -e moved_from \
        --include '\.(md|ya?ml)$' \
        "$WATCH_DIR" 2>/tmp/inotify.err | while IFS= read -r _event; do
        sleep "$DEBOUNCE_INTERVAL"
        CURRENT=$(fingerprint)
        if [ "$CURRENT" = "$LAST" ]; then
            continue
        fi
        echo "[entrypoint] $(date +%H:%M:%S) change detected -- rebuilding..."
        T0=$(date +%s)
        build
        T1=$(date +%s)
        echo "[entrypoint] $(date +%H:%M:%S) rebuild done in $((T1-T0))s (build-id $(cat $SITE_DIR/__build-id.txt)) -- browser will auto-reload."
        LAST=$CURRENT
    done
    # If we get here, inotifywait exited (recursive watch limit, EOF, etc.).
    echo "[entrypoint] inotifywait exited -- falling back to polling. stderr:"
    cat /tmp/inotify.err 2>/dev/null || true
    polling_loop
}

inotify_loop
