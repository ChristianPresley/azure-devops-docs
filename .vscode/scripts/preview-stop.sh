#!/usr/bin/env bash
# Stop the local docs-ui preview pipeline.

. "$(dirname "$0")/_common.sh"

stopped_any=false
# Stop the watchdog FIRST so it doesn't auto-restore wwwroot during shutdown.
if pgrep -f "$WATCHDOG_PATTERN" >/dev/null 2>&1; then
	echo "Stopping watchdog..."
	pkill -f "$WATCHDOG_PATTERN" 2>/dev/null || true
	stopped_any=true
	sleep 1
fi

# Kill any stray npm/wireit chain that would wipe wwwroot in a loop.
if find_hostile_processes >/dev/null; then
	echo "Killing stray npm/wireit chain (would wipe wwwroot in a loop)..."
	kill_hostile_processes
	stopped_any=true
	sleep 1
fi

for pattern in "${PROC_PATTERNS[@]}"; do
	if pgrep -f "$pattern" >/dev/null 2>&1; then
		echo "Stopping: $pattern"
		pkill -f "$pattern" 2>/dev/null || true
		stopped_any=true
	fi
done

# Give processes a moment to release ports.
sleep 2

# Force-kill anything that survived.
for pattern in "${PROC_PATTERNS[@]}"; do
	if pgrep -f "$pattern" >/dev/null 2>&1; then
		echo "Force-killing: $pattern"
		pkill -9 -f "$pattern" 2>/dev/null || true
	fi
done

if $stopped_any; then
	echo "Preview stopped."
else
	echo "No preview services were running."
fi

# Final port check.
sleep 1
remaining=()
for port in "${PORTS[@]}"; do
	if [[ -n "$(port_pids "$port")" ]]; then
		remaining+=("$port")
	fi
done
if (( ${#remaining[@]} > 0 )); then
	echo ""
	echo "WARNING: ports still in use: ${remaining[*]}"
	for port in "${remaining[@]}"; do
		pids=$(port_pids "$port")
		for pid in $pids; do
			cmd=$(ps -p "$pid" -o args= 2>/dev/null || true)
			echo "  :$port  PID $pid  $cmd"
		done
	done
	echo "If a port belongs to an unrelated process, free it with:"
	echo "  sudo kill -9 <pid>"
fi
