#!/usr/bin/env bash
# .claude/hooks/verify-file.sh
set -euo pipefail

F="$(jq -r '.tool_input.file_path // empty')"
[[ "$F" == *.java ]] || exit 0
cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"
./mvnw -q spotless:apply >/dev/null 2>&1 || true
exit 0
