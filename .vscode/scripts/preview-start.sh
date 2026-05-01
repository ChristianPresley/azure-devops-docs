#!/usr/bin/env bash
# Start the local docs-ui preview pipeline. Idempotent and self-healing.
#
# Decision tree on entry:
#   - Pipeline already healthy (services up + wwwroot populated + smoke test 200)
#       -> exit 0 with a friendly message.
#   - Services running but wwwroot empty / smoke test fails (the bug we hit)
#       -> repair: restore wwwroot, restart dcp-local, re-run smoke test.
#   - Some services running but not all
#       -> stop everything, then proceed to fresh start.
#   - Nothing running
#       -> fresh start: pre-flight port check, restore wwwroot, start all 3 services.

. "$(dirname "$0")/_common.sh"

# Wait until a port is listening, or fail.
wait_for_port() {
	local port="$1" timeout_s="${2:-15}" elapsed=0
	while ! port_listening "$port"; do
		sleep 1
		elapsed=$((elapsed + 1))
		if (( elapsed >= timeout_s )); then
			echo "ERROR: port $port did not become ready within ${timeout_s}s" >&2
			return 1
		fi
	done
}

start_dcp_local() {
	echo "Starting dcp-local on :3003 (log: $DCP_LOG)..."
	cd "$DOCFX_TEMPLATES_DIR"
	nohup node ./lib/serve-content.js > "$DCP_LOG" 2>&1 &
	disown || true
	wait_for_port 3003 15
}

start_render() {
	echo "Starting render server on :3001 (log: $RENDER_LOG)..."
	cd "$SERVER_DIR"
	DOCS_ENV=development-lcs \
	NODE_ENV=development \
	FORCE_HTTPS=true \
	PORT=3001 \
	LOG_LEVEL=warn \
		nohup node ./dist/server.js > "$RENDER_LOG" 2>&1 &
	disown || true
	wait_for_port 3001 20
}

start_browser_sync() {
	echo "Starting browser-sync on :443 (log: $BS_LOG)..."
	cd "$SERVER_DIR"
	nohup node ./lib/browser-sync.js > "$BS_LOG" 2>&1 &
	disown || true
	wait_for_port 443 15
}

start_watchdog() {
	# Kill any extras first (race-safe).
	local existing
	existing=$(pgrep -f "$WATCHDOG_PATTERN" | wc -l)
	if (( existing > 0 )); then
		echo "Cleaning up $existing existing watchdog process(es)..."
		pkill -f "$WATCHDOG_PATTERN" 2>/dev/null || true
		sleep 1
	fi
	echo "Starting wwwroot watchdog (log: $WATCH_LOG)..."
	nohup "$SCRIPT_DIR/preview-watch-wwwroot.sh" > "$WATCH_LOG" 2>&1 &
	disown || true
}

run_smoke_test_with_report() {
	local code
	code=$(smoke_test || true)
	echo "  /pipelines/get-started/what-is-azure-pipelines -> HTTP $code"
	[[ "$code" == "200" ]]
}

# ============================================================
# Pre-flight: kill any stray npm/wireit that would wipe wwwroot
# ============================================================
if find_hostile_processes >/dev/null 2>&1; then
	echo "Found stray npm/wireit chain that would wipe wwwroot:"
	find_hostile_processes | sed 's/^/  /'
	echo "Killing them before proceeding..."
	kill_hostile_processes
	sleep 2
fi

# ============================================================
# Decision: case 1 — fully healthy
# ============================================================
if all_services_running && wwwroot_is_healthy; then
	echo "Smoke testing..."
	if run_smoke_test_with_report; then
		# Make sure the watchdog is up too.
		if ! is_running "$WATCHDOG_PATTERN"; then
			echo ""
			echo "Starting watchdog (was missing)..."
			start_watchdog
		fi
		echo ""
		echo "Preview is already up and healthy: https://localhost/en-us/azure/devops/?view=azure-devops&branch=main"
		exit 0
	fi
	echo ""
	echo "Services up and wwwroot populated but smoke test failed. Falling through to repair."
fi

# ============================================================
# Decision: case 2 — services up but wwwroot is broken (the bug)
# ============================================================
if all_services_running && ! wwwroot_is_healthy; then
	count=$(wwwroot_file_count)
	echo "Detected broken state: services running but wwwroot has only $count files."
	echo "Repairing wwwroot from cache and restarting dcp-local..."
	new_count=$(restore_wwwroot)
	echo "wwwroot restored ($new_count files)"
	echo "Restarting dcp-local so it rescans wwwroot..."
	pkill -f "dcp-local" 2>/dev/null || true
	sleep 2
	start_dcp_local
	echo ""
	echo "Smoke testing..."
	if run_smoke_test_with_report; then
		echo ""
		echo "Preview repaired: https://localhost/en-us/azure/devops/?view=azure-devops&branch=main"
		exit 0
	fi
	echo "Repair did not restore the smoke test. Falling through to a full restart."
fi

# ============================================================
# Decision: case 3 — partial state, stop everything first
# ============================================================
if any_service_running; then
	echo "Some preview services are running but not all; stopping them before a clean start..."
	"$SCRIPT_DIR/preview-stop.sh" >/dev/null 2>&1 || true
fi

# ============================================================
# Decision: case 4 — fresh start
# ============================================================
echo "Pre-flight: checking ports 443/3001/3003 are free or owned by us..."
if ! check_ports_owned_or_free; then
	echo ""
	echo "ERROR: aborting because an unrelated process is holding one of our ports."
	echo "       Free the port (sudo kill -9 <pid>) and re-run."
	exit 1
fi

echo "Restoring wwwroot from cache..."
file_count=$(restore_wwwroot)
echo "wwwroot restored ($file_count files)"

start_dcp_local
start_render
start_browser_sync
start_watchdog

echo ""
echo "Smoke testing..."
if run_smoke_test_with_report; then
	echo ""
	echo "Preview is up: https://localhost/en-us/azure/devops/?view=azure-devops&branch=main"
else
	echo ""
	echo "WARNING: smoke test did not return 200. Run 'preview: status' to inspect logs."
	exit 1
fi
