#!/usr/bin/env bash
# Show running preview processes, listening ports, wwwroot health, smoke test, and recent log tails.

. "$(dirname "$0")/_common.sh"

# ============================================================
# Top-line health verdict (computed first so the user sees it immediately)
# ============================================================
verdict_lines=()
overall="HEALTHY"

if all_services_running; then
	verdict_lines+=("Services:  all 3 running")
elif any_service_running; then
	verdict_lines+=("Services:  PARTIAL — some running, some stopped")
	overall="BROKEN"
else
	verdict_lines+=("Services:  stopped")
	overall="STOPPED"
fi

count=$(wwwroot_file_count)
if wwwroot_is_healthy; then
	verdict_lines+=("wwwroot:   populated ($count files)")
else
	verdict_lines+=("wwwroot:   EMPTY OR BROKEN ($count files; needs restore from cache)")
	[[ "$overall" == "HEALTHY" ]] && overall="BROKEN"
fi

if [[ "$overall" == "STOPPED" ]]; then
	verdict_lines+=("Smoke:     skipped (services not running)")
else
	smoke_code=$(smoke_test || true)
	if [[ "$smoke_code" == "200" ]]; then
		verdict_lines+=("Smoke:     200 OK")
	else
		verdict_lines+=("Smoke:     HTTP $smoke_code (expected 200)")
		overall="BROKEN"
	fi
fi

echo "=== Pipeline state: $overall ==="
for line in "${verdict_lines[@]}"; do
	echo "  $line"
done

if [[ "$overall" == "BROKEN" ]]; then
	echo ""
	echo "  Fix: run the 'preview: start' task. It auto-detects this state and repairs."
fi

# ============================================================
# Detail sections (so users can dig in if they need to)
# ============================================================

echo ""
echo "=== Processes ==="
declare -A label_for=( ["dcp-local"]="dcp-local" ["dist/server\\.js"]="render" ["lib/browser-sync\\.js"]="browser-sync" )
for pat in "${PROC_PATTERNS[@]}"; do
	pids=$(pgrep -f "$pat" 2>/dev/null | tr '\n' ' ' || true)
	label="${label_for[$pat]}"
	if [[ -n "$pids" ]]; then
		echo "  $label: PID(s) $pids"
	else
		echo "  $label: not running"
	fi
done
# Watchdog
watchdog_pids=$(pgrep -f "$WATCHDOG_PATTERN" 2>/dev/null | tr '\n' ' ' || true)
if [[ -n "$watchdog_pids" ]]; then
	echo "  watchdog: PID(s) $watchdog_pids"
else
	echo "  watchdog: not running (wwwroot will not auto-recover from wireit wipes)"
fi

echo ""
echo "=== Ports ==="
for port in "${PORTS[@]}"; do
	pids=$(port_pids "$port")
	if [[ -z "$pids" ]]; then
		echo "  :$port  (free)"
	else
		# Check ownership: are these our processes?
		owned_marker=""
		for pid in $pids; do
			cmd=$(ps -p "$pid" -o args= 2>/dev/null || true)
			matched=0
			for opat in "${PROC_PATTERNS[@]}"; do
				if echo "$cmd" | grep -qE "$opat"; then matched=1; break; fi
			done
			[[ "$matched" -eq 0 ]] && owned_marker=" [UNRELATED PROCESS]"
		done
		echo "  :$port  PID(s) $pids$owned_marker"
	fi
done

echo ""
echo "=== Hostile processes (would wipe wwwroot) ==="
if find_hostile_processes 2>/dev/null; then
	echo ""
	echo "  WARNING: these processes will wipe wwwroot in a loop. Run 'preview: stop' to clean up."
else
	echo "  none"
fi

echo ""
echo "=== Last 5 lines of each log ==="
declare -A log_label=( ["$DCP_LOG"]="dcp-local" ["$RENDER_LOG"]="render" ["$BS_LOG"]="browser-sync" )
for path in "$DCP_LOG" "$RENDER_LOG" "$BS_LOG"; do
	echo "--- ${log_label[$path]} ($path) ---"
	if [[ -f "$path" ]]; then
		tail -5 "$path" 2>/dev/null || true
	else
		echo "  (no log yet)"
	fi
done
