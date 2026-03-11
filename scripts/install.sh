#!/bin/bash
# Claude Skills Toolkit — Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/toantran292/claude-skills/main/scripts/install.sh | bash

set -e

REPO="toantran292/claude-skills"
INSTALL_DIR="$HOME/.claude-skills"
SKILL_DIR="$HOME/.claude/skills"

echo "Installing Claude Skills Toolkit..."

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
  echo "Updating existing installation..."
  cd "$INSTALL_DIR" && git pull --ff-only origin main
else
  echo "Cloning $REPO..."
  git clone "https://github.com/$REPO.git" "$INSTALL_DIR"
fi

# Link skills
bash "$INSTALL_DIR/scripts/relink.sh"

echo ""
echo "Done! Skills linked to: $SKILL_DIR"
echo "To update later: cd $INSTALL_DIR && git pull && bash scripts/relink.sh"
