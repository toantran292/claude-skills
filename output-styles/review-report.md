# Output Style: Review Report

Use this format when producing code review reports.

## Template

```markdown
# Review Report: [branch-name]

**Date**: [date]
**Reviewer**: Claude Code
**Branch**: [branch] vs [base]
**Tech Stack**: [detected stack]

## Critical Issues

### [C1] [Title]
- **File**: [path:line]
- **Problem**: [what's wrong]
- **Why it matters**: [impact — security, data loss, crash, etc.]
- **Example scenario**: [how this fails in production]
- **Suggested fix**: [concrete code or approach]

## Major Issues

### [M1] [Title]
- **File**: [path:line]
- **Problem**: [what's wrong]
- **Why it matters**: [impact]
- **Suggested fix**: [concrete suggestion]

## Minor Issues

### [m1] [Title]
- **File**: [path:line]
- **Issue**: [description]
- **Suggestion**: [improvement]

## Suggestions

- [S1] [optional improvement]
- [S2] [alternative approach worth considering]

## Open Questions

- [things that need clarification from the author]

## Summary

| Severity | Count |
|----------|-------|
| Critical | X     |
| Major    | X     |
| Minor    | X     |
| Suggestions | X |

**Production Readiness**: X/10
**Verdict**: APPROVE / CHANGES REQUESTED
**Must fix before merge**: [list critical items]
```
