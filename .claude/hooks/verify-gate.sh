#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"
session_id="$(jq -r '.session_id // .sessionId // "default"' <<<"$input" | tr -cd '[:alnum:]_.-')"
project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
state_dir="$project_dir/.claude/.acdc-state"
state_file="$state_dir/${session_id:-default}.attempts"
mkdir -p "$state_dir"

if report="$(cd "$project_dir" && ./scripts/acdc-verify.sh --fast 2>&1)"; then
  rm -f "$state_file" "$state_dir/${session_id:-default}.fail"
  exit 0
fi

attempt=0
[[ -f "$state_file" ]] && attempt="$(cat "$state_file")"
attempt=$((attempt + 1))
printf '%s\n' "$attempt" > "$state_file"
printf '%s\n' "$report" > "$state_dir/${session_id:-default}.fail"

if (( attempt >= 3 )); then
  reason="AC/DC sigue fallando tras 3 intentos. Escala a un humano y no continúes: ${report:0:2000}"
else
  reason="AC/DC verify falló (intento $attempt/3). Corrige el problema antes de terminar: ${report:0:2000}"
fi

jq -n --arg reason "$reason" '{hookSpecificOutput:{hookEventName:"Stop",decision:"block",reason:$reason}}'
