---
name: implement-ticket
description: Turn a task or ticket into implemented, tested, reviewed, and PR-ready code changes.
argument-hint: "ticket description (e.g. 'Implement lead ingestion endpoint')"
disable-model-invocation: true
---

# Implement Ticket

End-to-end implementation of a ticket — from understanding through code, tests, review, fix, and PR.

## Input

Ticket: **$ARGUMENTS**

If no description provided, ask the user to describe the task.

## Process

### Step 1: Clarify the ticket

Confirm understanding before any code:
- What is the expected behavior?
- What are the acceptance criteria?
- Are there constraints or dependencies?

Ask clarifying questions if needed. Do not proceed until scope is agreed.

### Step 2: Scan architecture

Run `/architecture-scan` to understand:
- Which modules are affected
- What patterns to follow
- What dependencies exist

### Step 3: Plan implementation

Run `/implementation-plan $ARGUMENTS` to produce:
- Affected files and modules
- Implementation order
- Risks and mitigations
- Validation checklist

Present the plan to the user. Ask: **"Proceed with implementation?"**

### Step 4: Implement

Write the code following the plan:
- Apply standards from `.claude/rules/review.md`
- Follow existing codebase patterns
- Make small, focused changes — do not modify unrelated code

### Step 5: Generate tests

Run `/generate-tests` to:
- Identify changed files missing test coverage
- Write tests following existing project conventions
- Cover happy path, edge cases, and error cases
- Verify all tests pass

### Step 6: Review

Run `/review-branch` to review the changes. This produces a severity-ranked report.

If Critical or Major issues are found, proceed to Step 7. Otherwise, skip to Step 8.

### Step 7: Fix issues

If the review found issues:

1. Run `/remediation-plan from last review` to prioritize fixes
2. Run `/fix-branch` to apply the fixes
3. Self-verify: read the final diff and confirm all Critical/Major issues are resolved

### Step 8: Multi-repo validation (if applicable)

If the ticket spans multiple repositories:
- Run `/integration-check` to validate cross-service contracts
- Flag any API or event schema mismatches
- Fix mismatches before finalizing

### Step 9: Create PR

Run `/create-pr` to:
- Push the branch
- Create a pull request with structured description, test plan, and risks

Present the PR URL to the user.

### Step 10: Summary

Present the final result:

```
# Implementation Summary: [Ticket Title]

## Changes Made
| File | Change | Description |
|------|--------|-------------|
| ...  | new/modify | ... |

## Tests Added
| Test | Covers |
|------|--------|
| ...  | ...    |

## Review Result
- **Issues found**: [count by severity]
- **Issues fixed**: [count]
- **Remaining**: [count, if any]

## Pull Request
- **URL**: [pr-url]
- **Status**: Ready for review
```

## Limitations

- Will not push code or create PRs without user confirmation
- Review step may find issues that require design changes — the skill will stop and consult the user
- Multi-repo implementation requires running this skill per repo with coordination
- After PR is created, use `/address-feedback` to handle reviewer comments
