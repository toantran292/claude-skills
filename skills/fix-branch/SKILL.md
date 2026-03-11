---
name: fix-branch
description: Apply targeted fixes from any source — review reports, PR feedback, QA bugs, or direct instructions.
argument-hint: "what to fix (description, PR number, or 'from last review')"
---

# Fix Branch

Apply targeted fixes to the current branch.

## Input

Fix context: **$ARGUMENTS**

Accepts any of:
- **"from last review"** — use the most recent `/review-branch` or `/remediation-plan` output
- **PR feedback** — user pastes reviewer comments or provides a PR number
- **QA bugs** — user describes bugs found during QA
- **Direct description** — user describes specific issues to fix
- **No input** — ask the user what to fix; suggest `/review-branch` if unsure

## Process

### Step 1: Parse and categorize

Extract fix items from the input. Categorize by severity:
- **Critical** — must fix (blockers, security, data loss)
- **Major** — should fix (bugs, broken functionality)
- **Minor** — nice to fix (style, naming, minor improvements)

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

| # | Title | Source | Severity | Status |
|---|-------|--------|----------|--------|
| 1 | ...   | review/PR/QA | Critical | DONE |
| 2 | ...   | review/PR/QA | Major | SKIPPED |

Include:
- Fixes applied vs skipped
- Whether the branch is ready for re-review or merge
- Suggest running `/review-branch` again if critical fixes were applied
