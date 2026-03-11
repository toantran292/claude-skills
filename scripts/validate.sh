#!/bin/bash
# Validate repository structure and internal references
# Usage: bash scripts/validate.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
ERRORS=0

check() {
  if [ ! -e "$ROOT/$1" ]; then
    echo "MISSING: $1"
    ERRORS=$((ERRORS + 1))
  fi
}

echo "Validating Claude Skills Toolkit..."
echo ""

# Required top-level files
echo "--- Top-level files ---"
for f in README.md CLAUDE.md CHANGELOG.md; do
  check "$f"
done

# Required directories
echo "--- Directories ---"
for d in skills agents hooks output-styles .claude/rules docs examples scripts; do
  check "$d"
done

# Required skills (each must have SKILL.md)
echo "--- Skills ---"
for s in analyze-codebase design-feature implement-ticket address-feedback enhance-prompt architecture-scan implementation-plan review-branch remediation-plan fix-branch generate-tests create-pr integration-check create-skill; do
  check "skills/$s/SKILL.md"
done

# Required agents
echo "--- Agents ---"
for a in code-reviewer code-fixer security-reviewer prompt-engineer system-architect; do
  check "agents/$a.md"
done

# Required hooks
echo "--- Hooks ---"
check "hooks/README.md"
for h in after-review.example.sh after-fix.example.sh notify.example.sh protect-critical-files.example.sh; do
  check "hooks/$h"
done

# Required output styles
echo "--- Output styles ---"
for o in review-report.md fix-plan.md explanatory-dev.md; do
  check "output-styles/$o"
done

# Required rules
echo "--- Rules ---"
for r in review.md prompts.md repository-structure.md single-repo-workflow.md multi-repo-workflow.md; do
  check ".claude/rules/$r"
done

# Required docs
echo "--- Documentation ---"
for d in architecture.md migration-guide.md single-repo-usage.md multi-repo-usage.md references.md; do
  check "docs/$d"
done

# Required examples
echo "--- Examples ---"
for e in review-report.md fix-plan.md single-repo-session.md multi-repo-session.md; do
  check "examples/$e"
done

# Required scripts
echo "--- Scripts ---"
for s in install.sh relink.sh validate.sh init-rules.sh; do
  check "scripts/$s"
done

# Check for broken rule references in skills
echo "--- Internal references ---"
for skill in "$ROOT"/skills/*/SKILL.md; do
  while IFS= read -r ref; do
    # Extract path between backticks using sed (portable)
    ref_path=$(echo "$ref" | sed -n 's/.*`\([^`]*\)`.*/\1/p' | head -1)
    if [ -n "$ref_path" ] && echo "$ref_path" | grep -qE '^\.' ; then
      resolved="$ROOT/$ref_path"
      if [ ! -e "$resolved" ]; then
        echo "BROKEN REF in $(basename "$(dirname "$skill")")/SKILL.md: $ref_path"
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done < <(grep -n 'rules/\|output-styles/' "$skill" 2>/dev/null || true)
done

echo ""
if [ "$ERRORS" -eq 0 ]; then
  echo "All checks passed."
else
  echo "Found $ERRORS issue(s)."
  exit 1
fi
