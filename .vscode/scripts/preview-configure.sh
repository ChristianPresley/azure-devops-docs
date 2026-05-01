#!/usr/bin/env bash
# Interactive: list available wireit content-build caches and persist the chosen
# one to .vscode/preview.env so the start task uses it deterministically.

. "$(dirname "$0")/_common.sh"

echo "Wireit content-build caches under:"
echo "  $WIREIT_CACHE_DIR"
echo ""

mapfile -t CACHES < <(stat -c '%Y %n' "$WIREIT_CACHE_DIR"/*/wwwroot 2>/dev/null | sort -rn)

if [[ "${#CACHES[@]}" -eq 0 ]]; then
	echo "No caches found. The pipeline cannot bootstrap without a prior successful 'npm run content-build'."
	exit 1
fi

echo "Available caches (newest first):"
i=1
HASHES=()
for line in "${CACHES[@]}"; do
	mtime=$(echo "$line" | awk '{print $1}')
	path=$(echo "$line" | awk '{print $2}')
	hash=$(basename "$(dirname "$path")")
	HASHES+=("$hash")
	when=$(date -d "@$mtime" '+%Y-%m-%d %H:%M:%S')
	files=$(find "$path" -type f 2>/dev/null | wc -l)
	current_marker=""
	if [[ "$hash" == "${WIREIT_CACHE_HASH:-}" ]]; then
		current_marker=" (current)"
	fi
	printf "  %d) %s  %s  files=%d%s\n" "$i" "$when" "${hash:0:16}..." "$files" "$current_marker"
	i=$((i + 1))
done

echo ""
echo "  0) Auto-pick newest at start time (clears configured value)"
echo ""
read -rp "Choose a cache by number [default 1]: " CHOICE
CHOICE=${CHOICE:-1}

if [[ "$CHOICE" == "0" ]]; then
	NEW_HASH=""
	echo "Cleared. Start task will auto-pick newest cache."
elif [[ "$CHOICE" =~ ^[0-9]+$ ]] && (( CHOICE >= 1 && CHOICE <= ${#HASHES[@]} )); then
	NEW_HASH="${HASHES[$((CHOICE - 1))]}"
	echo "Selected: $NEW_HASH"
else
	echo "Invalid choice. No changes made."
	exit 1
fi

# Update WIREIT_CACHE_HASH line in preview.env in place.
if grep -q '^WIREIT_CACHE_HASH=' "$ENV_FILE"; then
	sed -i "s|^WIREIT_CACHE_HASH=.*|WIREIT_CACHE_HASH=\"$NEW_HASH\"|" "$ENV_FILE"
else
	echo "WIREIT_CACHE_HASH=\"$NEW_HASH\"" >> "$ENV_FILE"
fi

echo "Updated $ENV_FILE"
