# Single-Repo Usage

Step-by-step workflow for using this toolkit inside a single repository.

## One-command workflow

For a complete ticket implementation, use the orchestration skill:

```
/implement-ticket add user notification preferences with email and Slack channels
```

This runs the full cycle: scan → plan → implement → test → review → fix → PR → summary.

## Understand an unfamiliar codebase

```
/analyze-codebase
```

Produces a structured overview: architecture, modules, integrations, entry points, and complexity areas. Good for onboarding or before starting a large task.

## Design before implementing

```
/design-feature add Zillow lead ingestion support
```

Produces a system design proposal: architecture flow, affected modules, risks, and validation strategy. The design is saved to `.claude/design-<feature>.md` so `/implement-ticket` can read it — even in a new conversation.

## Full manual workflow

For maximum control, invoke focused skills in sequence:

### 1. Clarify the task

Understand requirements before coding. Ask:
- What exactly needs to change?
- What are the acceptance criteria?
- Are there constraints (backward compat, perf, etc.)?

### 2. Scan architecture

```
/architecture-scan
```

Understand the codebase: modules, dependencies, patterns, and likely affected areas.

### 3. Create implementation plan

```
/implementation-plan add user notification preferences with email and Slack channels
```

Get a concrete plan with affected files, implementation order, risks, and validation checklist.

### 4. Implement

Write the code following the plan. Claude Code applies the standards from `.claude/rules/review.md` automatically.

### 5. Generate tests

```
/generate-tests
```

Write tests for changed files. Follows existing test patterns — covers happy path, edge cases, and error cases.

### 6. Review

```
/review-branch
```

Get a structured review with severity-ranked issues. Review defaults to the current branch.

### 7. Remediate (if issues found)

```
/remediation-plan from last review
```

Convert review findings into a prioritized fix plan.

### 8. Fix

```
/fix-branch
```

Apply targeted fixes based on the remediation plan.

### 9. Create PR

```
/create-pr
```

Push the branch and create a pull request with structured description, test plan, and risks.

### 10. Address feedback

```
/address-feedback 42
```

Read PR review comments, categorize them, apply fixes, and push updates. Also works with pasted feedback or QA bugs.

### 11. QA fixes

If QA finds bugs:

```
/address-feedback from QA
```

Or for direct fixes:

```
/fix-branch fix login timeout on slow connections
```

## Quick workflow

For small changes (bug fixes, config changes, typos):

```
[make changes]
/review-branch
[fix any issues]
/create-pr
```

## Prompt enhancement workflow

When you need to craft a precise prompt:

```
/enhance-prompt tạo api cho payment processing với stripe webhook
```

Then use the enhanced prompt directly with Claude Code.
