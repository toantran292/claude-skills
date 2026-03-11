#!/bin/bash
# Re-symlink all skills without pulling from remote
# Useful for local development or fixing broken symlinks

set -e

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$HOME/.claude/skills"

mkdir -p "$SKILL_DIR"

for skill in "$INSTALL_DIR"/skills/*/; do
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
echo "Done! Skills linked to: $SKILL_DIR"
