---
name: address-feedback
description: Read PR review comments or QA feedback, categorize issues, apply fixes, and push updates.
argument-hint: "PR number, or paste feedback (e.g. 'gh pr view 42')"
disable-model-invocation: true
---

# Address Feedback

Read feedback from PR reviews or QA, categorize it, fix issues, and push.

## Input

Feedback source: **$ARGUMENTS**

Accepts:
- **PR number**: reads comments via `gh pr view <number>` and `gh api repos/{owner}/{repo}/pulls/<number>/reviews`
- **Pasted text**: user pastes reviewer comments or QA bug reports directly
- **"from QA"**: user describes QA findings in conversation

If no input, ask the user where the feedback is.

## Process

### Step 1: Collect feedback

**If PR number provided:**
```bash
gh pr view <number> --comments
gh api repos/{owner}/{repo}/pulls/<number>/reviews
```

Extract all review comments, inline comments, and requested changes.

**If pasted text or conversation:** parse the feedback as-is.

### Step 2: Categorize

Group feedback items by type:
- **Must fix** — reviewer marked "request changes" or blocker bugs from QA
- **Should fix** — suggestions the reviewer expects to be addressed
- **Optional** — nice-to-haves, style preferences, nit-picks
- **Questions** — items needing clarification (don't fix, respond instead)

Present the categorized list to the user. Ask:
> **Which items to address? (all / must-fix only / specific numbers)**

### Step 3: Fix

For each selected item, use the approach from `/fix-branch`:

1. **Read** the affected code and the reviewer's specific comment
2. **Understand** what the reviewer wants — not just the literal words
3. **Apply** the minimal change that addresses the feedback
4. **Verify** standards from `.claude/rules/review.md`
5. **Self-review** the diff

For **questions**: draft a reply comment, don't make code changes.

### Step 4: Respond

For each addressed item, prepare a response:
- **Fixed items**: "Fixed in [commit] — [brief description of change]"
- **Questions**: draft reply for the user to post
- **Declined items**: draft explanation for why it was not addressed

### Step 5: Push

```bash
git add -A && git commit -m "fix: address review feedback — [brief summary]"
git push
```

**Important**: Follow Conventional Commits. Do NOT include `Co-Authored-By` trailers.

Ask user to confirm before pushing.

### Step 6: Summary

```
## Feedback Addressed

### Fixed
| # | Feedback | Action taken |
|---|----------|-------------|
| 1 | ...      | Fixed: [what changed] |

### Responses (for user to post)
| # | Feedback | Suggested reply |
|---|----------|----------------|
| 2 | ...      | [draft reply] |

### Not addressed
| # | Feedback | Reason |
|---|----------|--------|
| 3 | ...      | [why skipped] |

**Commits**: [list of new commits]
**Status**: Ready for re-review / Needs discussion on items X, Y
```

## Limitations

- Requires `gh` CLI for reading PR comments; falls back to pasted text
- Cannot post reply comments automatically — provides drafts for user to post
- QA feedback must be described by the user; no integration with bug trackers
