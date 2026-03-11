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

# Ensure CLAUDE.md exists with commit conventions
CLAUDE_MD="$TARGET/CLAUDE.md"
if [ ! -f "$CLAUDE_MD" ]; then
  cat > "$CLAUDE_MD" << 'HEREDOC'
# Project

## Commit conventions

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
- **Scope**: optional, identifies the affected area (e.g. `feat(api): ...`, `fix(auth): ...`)
- **Breaking changes**: add `!` after type/scope (e.g. `feat!: ...`) or `BREAKING CHANGE:` footer
- NEVER include `Co-Authored-By` trailers from Claude or any AI agent in commits

## Quality standards

All code-related skills follow the standards defined in `.claude/rules/review.md`.
HEREDOC
  echo "  OK CLAUDE.md (created)"
elif ! grep -q "Conventional Commits" "$CLAUDE_MD"; then
  cat >> "$CLAUDE_MD" << 'HEREDOC'

## Commit conventions

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
- **Scope**: optional, identifies the affected area (e.g. `feat(api): ...`, `fix(auth): ...`)
- **Breaking changes**: add `!` after type/scope (e.g. `feat!: ...`) or `BREAKING CHANGE:` footer
- NEVER include `Co-Authored-By` trailers from Claude or any AI agent in commits
HEREDOC
  echo "  OK CLAUDE.md (appended commit conventions)"
else
  echo "  SKIP CLAUDE.md (commit conventions already present)"
fi

echo ""
echo "Done. Rules, output styles, and CLAUDE.md initialized in: $TARGET"
echo "Skills will now have full context when used in this project."
