#!/usr/bin/env bash
# Common shell helpers for preview-* tasks.
# Source from each task script: . "$(dirname "$0")/_common.sh"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../preview.env"

if [[ ! -f "$ENV_FILE" ]]; then
	echo "ERROR: $ENV_FILE not found. Run the 'preview: configure' task first." >&2
	exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

DOCFX_TEMPLATES_DIR="$DOCS_UI_ROOT/packages/docfx-templates"
SERVER_DIR="$DOCS_UI_ROOT/packages/server"
WIREIT_CACHE_DIR="$DOCFX_TEMPLATES_DIR/.wireit/636f6e74656e742d6275696c64/cache"
WWWROOT="$DOCFX_TEMPLATES_DIR/wwwroot"

# Process patterns we own. Centralized so start/stop/status agree.
PROC_PATTERNS=("dcp-local" "dist/server\\.js" "lib/browser-sync\\.js")
# Ports we own.
PORTS=(443 3001 3003)
# A test URL that must return 200 if the pipeline is healthy.
SMOKE_URL="https://localhost/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops&branch=main"

# Pick the configured cache hash, or the newest one on disk.
resolve_cache_hash() {
	if [[ -n "${WIREIT_CACHE_HASH:-}" && -d "$WIREIT_CACHE_DIR/$WIREIT_CACHE_HASH/wwwroot" ]]; then
		echo "$WIREIT_CACHE_HASH"
		return 0
	fi
	local newest
	newest=$(stat -c '%Y %n' "$WIREIT_CACHE_DIR"/*/wwwroot 2>/dev/null \
		| sort -rn | head -1 | awk '{print $2}')
	if [[ -z "$newest" ]]; then
		echo "ERROR: no wireit content-build cache found under $WIREIT_CACHE_DIR" >&2
		echo "       This pipeline can't bootstrap without a prior successful build." >&2
		return 1
	fi
	basename "$(dirname "$newest")"
}

# True if a process matching the regex is alive.
is_running() {
	pgrep -f "$1" >/dev/null 2>&1
}

# True if all three preview services are running.
all_services_running() {
	local pat
	for pat in "${PROC_PATTERNS[@]}"; do
		is_running "$pat" || return 1
	done
	return 0
}

# True if any of the three preview services are running.
any_service_running() {
	local pat
	for pat in "${PROC_PATTERNS[@]}"; do
		is_running "$pat" && return 0
	done
	return 1
}

# Count files in wwwroot. 0 if missing.
wwwroot_file_count() {
	[[ -d "$WWWROOT" ]] || { echo 0; return; }
	find "$WWWROOT" -type f 2>/dev/null | wc -l
}

# True if wwwroot looks populated (has the docs/test/ tree).
wwwroot_is_healthy() {
	local count
	count=$(wwwroot_file_count)
	[[ "$count" -ge 100 ]] && [[ -d "$WWWROOT/docs/test" ]]
}

# True if the given port has a listener.
port_listening() {
	ss -tln 2>/dev/null | awk '{print $4}' | grep -qE "(:|^)${1}\$"
}

# PID(s) of any process listening on the given port.
port_pids() {
	local port="$1"
	local pids
	pids=$(ss -tlnp 2>/dev/null | grep ":${port} " | grep -oP 'pid=\K[0-9]+' | sort -u | tr '\n' ' ')
	if [[ -z "$pids" ]] && command -v lsof >/dev/null 2>&1; then
		pids=$(lsof -ti:"$port" -sTCP:LISTEN 2>/dev/null | sort -u | tr '\n' ' ')
	fi
	echo "$pids"
}

# Run a smoke test against the running pipeline. Echoes HTTP code; returns 0 iff 200.
smoke_test() {
	local code
	code=$(curl -sk -o /dev/null --max-time 5 -w "%{http_code}" "$SMOKE_URL" 2>/dev/null || echo "000")
	echo "$code"
	[[ "$code" == "200" ]]
}

# Bail if any owned port is held by a process we don't recognize. Returns 0 if
# all ports are either free or held by our own services.
check_ports_owned_or_free() {
	local port pids pid pat conflict=0
	for port in "${PORTS[@]}"; do
		pids=$(port_pids "$port")
		[[ -z "$pids" ]] && continue
		for pid in $pids; do
			local cmd
			cmd=$(ps -p "$pid" -o args= 2>/dev/null || true)
			[[ -z "$cmd" ]] && continue
			local owned=0
			for pat in "${PROC_PATTERNS[@]}"; do
				if echo "$cmd" | grep -qE "$pat"; then owned=1; break; fi
			done
			if [[ "$owned" -eq 0 ]]; then
				echo "ERROR: port $port is held by an unrelated process (PID $pid):" >&2
				echo "  $cmd" >&2
				conflict=1
			fi
		done
	done
	[[ "$conflict" -eq 0 ]]
}

# Restore wwwroot from the configured (or newest) wireit cache.
# Echoes the file count on success on stdout.
restore_wwwroot() {
	local cache_hash
	cache_hash=$(resolve_cache_hash) || return 1
	echo "Using wireit cache: $cache_hash" >&2
	rm -rf "$WWWROOT"
	mkdir -p "$WWWROOT"
	# The trailing /. on the source copies CONTENTS, not the directory itself.
	# Hitting that bug once cost an hour; do not change.
	cp -r "$WIREIT_CACHE_DIR/$cache_hash/wwwroot/." "$WWWROOT/"
	wwwroot_file_count
}
