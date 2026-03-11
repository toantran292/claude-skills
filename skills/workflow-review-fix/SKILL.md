---
name: workflow-review-fix
description: Full review-fix-recheck workflow for a branch. Reviews code across repos, generates fix plan, applies fixes, then re-reviews to verify.
argument-hint: "branch-name"
disable-model-invocation: true
---

# Review → Fix → Re-Review Cycle

You are running a full code quality cycle for branch `$ARGUMENTS`.

**CRITICAL: Execute each phase fully before moving to the next. Ask user for confirmation between phases.**

## Phase 0: Setup

Ensure the output directory exists before anything else:
```bash
mkdir -p ./claude-context/$ARGUMENTS
```

Detect if this is a **repeat cycle** by checking for existing files:
```bash
ls ./claude-context/$ARGUMENTS/review.md ./claude-context/$ARGUMENTS/fix-plan.md ./claude-context/$ARGUMENTS/re-review.md 2>/dev/null
```

If `re-review.md` exists, this is cycle 2+. Determine the cycle number:
```bash
ls ./claude-context/$ARGUMENTS/re-review*.md 2>/dev/null | wc -l
```

**If repeat cycle (previous files exist):**
- Archive previous cycle files before overwriting:
```bash
CYCLE_NUM=$(ls ./claude-context/$ARGUMENTS/re-review*.md 2>/dev/null | wc -l | tr -d ' ')
mkdir -p ./claude-context/$ARGUMENTS/history
cp ./claude-context/$ARGUMENTS/review.md ./claude-context/$ARGUMENTS/history/review-cycle${CYCLE_NUM}.md 2>/dev/null
cp ./claude-context/$ARGUMENTS/fix-plan.md ./claude-context/$ARGUMENTS/history/fix-plan-cycle${CYCLE_NUM}.md 2>/dev/null
cp ./claude-context/$ARGUMENTS/fix-summary.md ./claude-context/$ARGUMENTS/history/fix-summary-cycle${CYCLE_NUM}.md 2>/dev/null
cp ./claude-context/$ARGUMENTS/re-review.md ./claude-context/$ARGUMENTS/history/re-review-cycle${CYCLE_NUM}.md 2>/dev/null
```
- Read the previous `re-review.md` to understand what was already fixed and what remains
- Inform the user: "This is cycle N+1. Previous cycle archived to `history/`. Focusing on remaining issues."

## Phase 1: Initial Review

Run the review-branch skill:

```
/review-branch $ARGUMENTS
```

This will:
1. Regenerate `review-config.json` (always fresh scan of repos)
2. Ask which repos to review
3. Perform Staff/Principal Engineer level review
4. Generate `./claude-context/$ARGUMENTS/review.md` and `./claude-context/$ARGUMENTS/fix-plan.md`

**If repeat cycle:** After generating the new review, cross-reference with the previous cycle's `re-review.md` from history:
- Flag issues that were marked RESOLVED but reappeared (regressions)
- Flag issues that persist from previous cycle (not yet fixed)
- Highlight genuinely new issues not seen before

After Phase 1 completes, present a summary to the user:
- Total issues found per severity (Critical / High / Medium / Low)
- Production readiness score
- Number of fixes in the plan
- **If repeat cycle:** How many are carry-overs vs new issues

Ask the user: **"Proceed to Phase 2 (Fix)? Or review the files first?"**

## Phase 2: Apply Fixes

Run the fix-branch skill:

```
/fix-branch $ARGUMENTS
```

This will:
1. Read the fix-plan.md
2. Present fixes for selection
3. Apply fixes one-by-one with verification
4. Generate `./claude-context/$ARGUMENTS/fix-summary.md`

After Phase 2 completes, present:
- How many fixes applied vs skipped
- Any fixes that failed

Ask the user: **"Proceed to Phase 3 (Re-Review)? Or stop here?"**

## Phase 3: Re-Review

Perform a focused re-review on the same repos/branch. This time:

1. Read the original review at `./claude-context/$ARGUMENTS/review.md`
2. Read the fix summary at `./claude-context/$ARGUMENTS/fix-summary.md`
3. Get the current diff again for each repo:
```bash
cd <repo-path> && git diff origin/<base-branch>...origin/$ARGUMENTS
```

4. For each original issue that was marked as fixed:
   - Verify the fix actually resolves the issue
   - Check for regressions introduced by the fix
   - Check SOLID/ACID compliance of the fix

5. Check for NEW issues introduced by the fixes

6. Generate re-review report at `./claude-context/$ARGUMENTS/re-review.md`:

```markdown
# Re-Review Report for branch: $ARGUMENTS
Date: <current date>

## Original Issues Status
| # | Issue | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 1 | ...   | Critical | RESOLVED | Fix verified |
| 2 | ...   | High     | PARTIALLY RESOLVED | Still has edge case |
| 3 | ...   | Medium   | NOT FIXED | Was skipped |

## New Issues Introduced by Fixes
(List any regressions or new problems)

## Updated Production Readiness Score
- Before fixes: X/10
- After fixes: Y/10

## Final Verdict
- [ ] APPROVED - Ready to merge
- [ ] CHANGES REQUESTED - See remaining issues
- [ ] NEEDS ANOTHER CYCLE - Run /workflow-review-fix again

## Remaining Action Items
1. ...
```

## Phase 4: Final Summary

Present the complete cycle results:
- Original score → New score
- Issues resolved / remaining / new
- Final recommendation: merge, another cycle, or manual review needed

All output files are in `./claude-context/$ARGUMENTS/`:
- `review.md` - Current cycle review
- `fix-plan.md` - Current cycle fix plan (with status updates)
- `fix-summary.md` - What was fixed this cycle
- `re-review.md` - Current cycle verification
- `history/` - Previous cycle archives (review-cycle1.md, fix-plan-cycle1.md, etc.)
