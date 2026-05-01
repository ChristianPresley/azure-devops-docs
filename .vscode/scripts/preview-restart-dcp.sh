#!/usr/bin/env bash
# Restart only dcp-local. Use this after dropping new files into wwwroot/
# (dcp-local scans wwwroot once at startup; new files won't be visible without a restart).

. "$(dirname "$0")/_common.sh"

if ! wwwroot_is_healthy; then
	count=$(wwwroot_file_count)
	echo "ERROR: wwwroot looks empty or broken ($count files)."
	echo "       Run the 'preview: start' task instead — it auto-restores wwwroot."
	exit 1
fi

if is_running "dcp-local"; then
	echo "Stopping dcp-local..."
	pkill -f "dcp-local" 2>/dev/null || true
	sleep 2
fi

cd "$DOCFX_TEMPLATES_DIR"
echo "Starting dcp-local on :3003 (log: $DCP_LOG)..."
nohup node ./lib/serve-content.js > "$DCP_LOG" 2>&1 &
disown || true

# Wait for the port to come back.
for i in $(seq 1 15); do
	if port_listening 3003; then break; fi
	sleep 1
done

if is_running "dcp-local" && port_listening 3003; then
	echo "dcp-local restarted."
else
	echo "WARNING: dcp-local did not come up. Tail of log:"
	tail -10 "$DCP_LOG" 2>/dev/null || true
	exit 1
fi
