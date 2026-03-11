#!/bin/bash
# Re-symlink all skills to ~/.claude/skills/
# Usage: bash scripts/relink.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$(dirname "$SCRIPT_DIR")"
SKILL_DIR="$HOME/.claude/skills"

mkdir -p "$SKILL_DIR"

# Remove stale symlinks pointing to this installation
for link in "$SKILL_DIR"/*; do
  [ -L "$link" ] || continue
  target=$(readlink "$link")
  case "$target" in
    "$INSTALL_DIR"/skills/*)
      if [ ! -e "$link" ]; then
        name=$(basename "$link")
        rm "$link"
        echo "  REMOVED $name (skill no longer exists)"
      fi
      ;;
  esac
done

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
