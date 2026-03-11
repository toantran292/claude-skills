#!/bin/bash
# Example: Block edits to critical files (migrations, configs, CI)
# Copy to .claude/hooks/protect-critical-files.sh and configure in settings
#
# Usage as a "before" hook on Edit/Write tools:
#   "before_tool_use": [{"matcher": "Edit|Write", "command": ".claude/hooks/protect-critical-files.sh"}]

FILE_PATH="${1:-}"

# Define protected patterns (customize for your project)
PROTECTED_PATTERNS=(
  "db/migrate"
  ".github/workflows"
  "docker-compose"
  ".env"
  "Dockerfile"
  "terraform/"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -q "$pattern"; then
    echo "BLOCKED: $FILE_PATH matches protected pattern '$pattern'"
    echo "Remove this hook or update the pattern list to allow edits."
    exit 1
  fi
done

exit 0
