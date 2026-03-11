#!/bin/bash
# Re-symlink all skills to ~/.claude/skills/
# Usage: bash scripts/relink.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$(dirname "$SCRIPT_DIR")"
SKILL_DIR="$HOME/.claude/skills"

mkdir -p "$SKILL_DIR"

for skill in "$INSTALL_DIR"/skills/*/; do
  [ -f "$skill/SKILL.md" ] || continue

  name=$(basename "$skill")
  target="$SKILL_DIR/$name"

  if [ -L "$target" ]; then
    rm "$target"
  elif [ -d "$target" ]; then
    echo "  SKIP $name (local copy exists, not a symlink)"
    continue
  fi

  ln -s "$skill" "$target"
  echo "  OK $name"
done

echo ""
echo "Skills linked to: $SKILL_DIR"
