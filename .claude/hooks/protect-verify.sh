#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"
file="$(jq -r '.tool_input.file_path // empty' <<<"$input")"
file="${file#${CLAUDE_PROJECT_DIR:-}/}"

case "$file" in
  config/*|.claude/*|.opencode/*|.github/*|pom.xml|.env|.env.*)
    jq -n --arg file "$file" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:("Zona AC/DC protegida: " + $file + ". Pide autorización humana explícita.")}}'
    ;;
esac
