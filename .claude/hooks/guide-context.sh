#!/usr/bin/env bash
set -euo pipefail

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
branch="$(git -C "$project_dir" branch --show-current 2>/dev/null || echo 'sin rama')"
state_dir="$project_dir/.claude/.acdc-state"
open_findings=0
[[ -d "$state_dir" ]] && open_findings="$(find "$state_dir" -type f -name '*.fail' | wc -l | tr -d ' ')"

jq -n --arg branch "$branch" --arg findings "$open_findings" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:("AC/DC: rama=" + $branch + ". PIT desde S15: mínimo 80 % global y 70 % por clase modificada. Hallazgos abiertos: " + $findings + ". Ejecuta ./scripts/acdc-verify.sh --fast; la zona protegida requiere permiso humano.")}}'
