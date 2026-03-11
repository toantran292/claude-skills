#!/bin/bash
# Claude Skills Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/toantran292/claude-skills/main/install.sh | bash

set -e

REPO="toantran292/claude-skills"
INSTALL_DIR="$HOME/.claude-skills"
SKILL_DIR="$HOME/.claude/skills"

echo "🔧 Installing Claude Skills..."

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
  echo "Updating existing installation..."
  cd "$INSTALL_DIR" && git pull --ff-only origin main
else
  echo "Cloning $REPO..."
  git clone "https://github.com/$REPO.git" "$INSTALL_DIR"
fi

# Ensure skills directory exists
mkdir -p "$SKILL_DIR"

# Symlink each skill
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
echo "Done! Installed skills:"
ls -1 "$INSTALL_DIR"/skills/
echo ""
echo "Skills linked to: $SKILL_DIR"
echo "To update later: cd $INSTALL_DIR && git pull"
