#!/bin/bash
# Copy shared rules and output styles into the current project
# Usage: bash ~/.claude-skills/scripts/init-rules.sh [target-dir]
#
# This ensures skills like /review-branch, /fix-branch, /generate-tests
# have access to shared standards when used in any project.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$(dirname "$SCRIPT_DIR")"
TARGET="${1:-.}"

# Resolve to absolute path
TARGET="$(cd "$TARGET" && pwd)"

echo "Initializing Claude rules in: $TARGET"

# Copy rules
mkdir -p "$TARGET/.claude/rules"
for rule in "$SOURCE_DIR"/.claude/rules/*.md; do
  name=$(basename "$rule")
  if [ -f "$TARGET/.claude/rules/$name" ]; then
    echo "  SKIP .claude/rules/$name (already exists)"
  else
    cp "$rule" "$TARGET/.claude/rules/$name"
    echo "  OK .claude/rules/$name"
  fi
done

# Copy output styles
mkdir -p "$TARGET/output-styles"
for style in "$SOURCE_DIR"/output-styles/*.md; do
  name=$(basename "$style")
  if [ -f "$TARGET/output-styles/$name" ]; then
    echo "  SKIP output-styles/$name (already exists)"
  else
    cp "$style" "$TARGET/output-styles/$name"
    echo "  OK output-styles/$name"
  fi
done

echo ""
echo "Done. Rules and output styles copied to: $TARGET"
echo "Skills will now have full context when used in this project."
