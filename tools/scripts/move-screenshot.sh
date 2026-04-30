#!/usr/bin/env bash
# Move (or copy) Playwright MCP screenshots from .playwright-output/ into a
# docs media folder, with optional rename.
#
# Usage:
#   tools/scripts/move-screenshot.sh <source-name> <dest-rel-path> [--copy]
#
# Examples:
#   # Move .playwright-output/test-signin.png to docs/pipelines/media/agents/signin.png
#   tools/scripts/move-screenshot.sh test-signin.png docs/pipelines/media/agents/signin.png
#
#   # Copy instead of move
#   tools/scripts/move-screenshot.sh page-2026-04-30T04-25-07.png \
#       docs/pipelines/media/agents/landing.png --copy
#
# The script resolves <dest-rel-path> relative to the workspace root, creates
# the destination directory if needed, and refuses to overwrite existing files.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SOURCE_DIR="${WORKSPACE_ROOT}/.playwright-output"

if [[ $# -lt 2 || $# -gt 3 ]]; then
    sed -n '2,17p' "${BASH_SOURCE[0]}" >&2
    exit 2
fi

src_name="$1"
dest_rel="$2"
mode="move"
if [[ ${3:-} == "--copy" ]]; then
    mode="copy"
elif [[ -n ${3:-} ]]; then
    echo "error: unknown flag '$3' (expected --copy)" >&2
    exit 2
fi

src_path="${SOURCE_DIR}/${src_name}"
dest_path="${WORKSPACE_ROOT}/${dest_rel}"

# Reject absolute paths and parent traversal in dest_rel.
case "$dest_rel" in
    /*|*..*) echo "error: destination must be a workspace-relative path without '..': ${dest_rel}" >&2; exit 1 ;;
esac

if [[ ! -f $src_path ]]; then
    echo "error: source not found: ${src_path}" >&2
    exit 1
fi

# Defense in depth: ensure resolved destination is inside the workspace.
case "$dest_path" in
    "${WORKSPACE_ROOT}"/*) ;;
    *) echo "error: destination must be inside workspace: ${dest_rel}" >&2; exit 1 ;;
esac

if [[ -e $dest_path ]]; then
    echo "error: destination already exists: ${dest_path}" >&2
    exit 1
fi

mkdir -p "$(dirname "$dest_path")"

if [[ $mode == "copy" ]]; then
    cp "$src_path" "$dest_path"
    echo "copied  ${src_path} -> ${dest_path}"
else
    mv "$src_path" "$dest_path"
    echo "moved   ${src_path} -> ${dest_path}"
fi
