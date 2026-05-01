#!/usr/bin/env bash
# Background watchdog that auto-restores wwwroot if something wipes it
# (typically wireit re-evaluation after a git commit / npm install in docs-ui).
#
# Started by preview-start.sh and stopped by preview-stop.sh.
# Polls wwwroot every WATCH_INTERVAL_S seconds; when it sees the file count
# drop below the healthy floor, it restores from cache and bounces dcp-local.

. "$(dirname "$0")/_common.sh"

WATCH_INTERVAL_S=${PREVIEW_WATCH_INTERVAL:-5}
HEALTHY_FILE_FLOOR=100   # any non-empty cached docset has thousands of files

log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log "wwwroot watchdog started (PID $$, interval ${WATCH_INTERVAL_S}s)"

while true; do
	count=$(wwwroot_file_count)
	if (( count < HEALTHY_FILE_FLOOR )); then
		log "Detected wwwroot wipe ($count files); auto-restoring..."
		new_count=$(restore_wwwroot 2>/dev/null)
		log "Restored $new_count files. Bouncing dcp-local..."
		pkill -f "dcp-local" 2>/dev/null || true
		sleep 2
		(cd "$DOCFX_TEMPLATES_DIR" && nohup node ./lib/serve-content.js >> "$DCP_LOG" 2>&1 &)
		log "dcp-local restarted."
	fi
	sleep "$WATCH_INTERVAL_S"
done
