# Output Style: Fix Plan

Use this format when producing remediation or fix plans.

## Template

```markdown
# Fix Plan: [branch-name or task]

**Date**: [date]
**Source**: [review report / user request / remediation plan]

## Issues

| # | Title | Severity | Files | Status |
|---|-------|----------|-------|--------|
| 1 | ...   | Critical | ...   | PENDING |
| 2 | ...   | Major    | ...   | PENDING |

## Fix Strategy

Execution order based on dependency and severity:
1. [Fix critical/blocking issues first]
2. [Then major issues]
3. [Then minor/cleanup]

## Execution Steps

### Fix 1: [Title] — Critical
- **Problem**: [description]
- **Files**: [affected files]
- **Steps**:
  1. [concrete change]
  2. [concrete change]
- **Validation**: [how to verify the fix]
- **Risk**: [what could go wrong]

### Fix 2: [Title] — Major
...

## Validation

After all fixes:
- [ ] All tests pass
- [ ] No regressions in related functionality
- [ ] Self-review of all diffs
- [ ] [Task-specific checks]
```
