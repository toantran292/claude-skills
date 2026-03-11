#!/bin/bash
# Example: Run tests after /fix-branch applies changes
# Copy to .claude/hooks/after-fix.sh and configure in settings

echo "Running tests after fix..."

# Detect test runner
if [ -f "package.json" ]; then
  npm test 2>&1 | tail -20
elif [ -f "Gemfile" ]; then
  bundle exec rspec 2>&1 | tail -20
elif [ -f "go.mod" ]; then
  go test ./... 2>&1 | tail -20
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
  python -m pytest 2>&1 | tail -20
else
  echo "No test runner detected"
fi
