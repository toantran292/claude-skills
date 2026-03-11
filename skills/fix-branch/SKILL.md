---
name: fix-branch
description: Apply targeted fixes based on a review report or remediation plan.
argument-hint: "branch-name (optional, defaults to current branch)"
---

# Fix Branch

Apply fixes from a review or remediation plan to the current branch.

## Input

Branch to fix: **$ARGUMENTS**

If no branch name provided, use the current branch.

## Process

### Step 1: Load context

Look for fix context in this order:
1. Ask the user what to fix (they may paste issues or reference a review)
2. Check if a remediation plan or review was recently produced in the conversation

If no context is found, suggest running `/review-branch` first.

### Step 2: Present and select

Present all fixes as a numbered list with severity. Ask the user which to apply:
- All
- Specific numbers
- By severity level (e.g. "all Critical and Major")

### Step 3: Apply fixes

For each selected fix, in priority order:

1. **Read** affected files and surrounding context (callers, related code)
2. **Understand** the why before changing anything
3. **Apply** the minimal change needed — no gold-plating
4. **Verify** standards from `.claude/rules/review.md` are met
5. **Self-review** — read your own diff, ask: would I approve this in a PR?
6. **Test** — run relevant tests if they exist

After each fix, show:
- What changed (brief summary)
- Verification result
- Ask: continue, skip next, or stop?

### Step 4: Summary

After all fixes are applied, present:

| # | Title | Severity | Status |
|---|-------|----------|--------|
| 1 | ...   | Critical | DONE   |
| 2 | ...   | Major    | SKIPPED |

Include:
- Fixes applied vs skipped
- Whether the branch is ready for re-review or merge
- Suggest running `/review-branch` again if critical fixes were applied
