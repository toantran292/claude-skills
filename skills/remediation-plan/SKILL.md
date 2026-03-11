---
name: remediation-plan
description: Convert review findings into a prioritized remediation plan with fixes, validation steps, and risk assessment.
argument-hint: "paste review findings or say 'from last review'"
---

# Remediation Plan

Convert a code review report into a prioritized, actionable remediation plan.

## Input

Review findings: **$ARGUMENTS**

If the user says "from last review" or similar, use the most recent review output from the conversation. If no review context exists, suggest running `/review-branch` first.

## Process

### Step 1: Parse findings

Extract all issues from the review, categorized by severity:
- **Critical** — must fix before merge
- **Major** — should fix before merge
- **Minor** — fix when convenient
- **Suggestions** — optional improvements

### Step 2: Prioritize

Group issues by priority considering:
- Severity (Critical first)
- Dependency order (fix foundation before dependent code)
- Risk of regression (isolated fixes before cross-cutting changes)
- Effort (quick wins grouped together)

### Step 3: Produce the plan

Use the format from `.claude/output-styles/fix-plan.md`:

```
## Remediation Plan

### Priority 1: Critical Issues
| # | Issue | Files | Fix Strategy |
|---|-------|-------|-------------|
| 1 | ...   | ...   | ...         |

#### Fix 1: [Title]
- **Problem**: [what's wrong]
- **Fix**: [concrete steps]
- **Validation**: [how to verify]
- **Risk**: [what could go wrong with this fix]

### Priority 2: Major Issues
...

### Priority 3: Minor Issues
...

### Deferred (Suggestions)
...

### Follow-up Risks
- [risks introduced by the fixes themselves]
- [areas that need monitoring after fixes]
```

### Step 4: Verify completeness

- Every issue from the review is accounted for (fixed or explicitly deferred)
- Fixes don't contradict each other
- Validation steps are specific and testable
