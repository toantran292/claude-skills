---
name: fix-ci
description: Read failing CI checks from a PR, diagnose errors, apply fixes, and push.
argument-hint: "PR number (e.g. '42') or 'current' for current branch PR"
---

# Fix CI

Diagnose and fix failing CI checks on a pull request.

## Input

PR: **$ARGUMENTS**

Accepts:
- **PR number** — reads CI check results for that PR
- **"current"** — finds the PR for the current branch
- **No input** — detects PR from current branch, or asks for a number

## Process

### Step 1: Identify the PR

```bash
# If no PR number, find from current branch
gh pr view --json number,headRefName,url 2>/dev/null
```

If no PR is found, ask the user for a PR number.

### Step 2: Get failing checks

```bash
gh pr checks <number> --json name,state,link,workflow,bucket,event
```

Available fields: `bucket`, `completedAt`, `description`, `event`, `link`, `name`, `startedAt`, `state`, `workflow`.

List all checks and their status. Focus on checks where `state` is `FAILURE`.

The `link` field contains the URL to the check run (e.g. `https://github.com/org/repo/actions/runs/12345/job/67890`). Extract the **run ID** from the URL path: it's the number after `/runs/`.

### Step 3: Read failure details

Extract the **run ID** from the `link` URL: it's the number after `/runs/`.
Example: `https://github.com/org/repo/actions/runs/22949152885/job/66609108920` → run ID is `22949152885`.

**Approach A: Annotations (fast, recommended)**

```bash
# Get error annotations — concise summary of all failures
gh api repos/{owner}/{repo}/actions/runs/<run-id>/annotations --jq '.[] | select(.annotation_level == "failure") | {path, start_line, message}'
```

If the annotations endpoint is unavailable or empty, use the check run annotations:
```bash
# Get job IDs first
gh run view <run-id> --json jobs --jq '.jobs[] | select(.conclusion == "failure") | {name, id: .databaseId}'

# Get annotations per job
gh api repos/{owner}/{repo}/check-runs/<job-id>/annotations --jq '.[] | {path, start_line, message, annotation_level}'
```

Annotations contain: file path, line number, and error message — enough to diagnose and fix without reading full logs.

**Approach B: Full logs (when annotations are insufficient)**

```bash
gh run view <run-id> --log-failed
```

If output is too large, read per job:
```bash
gh run view <run-id> --log --job-id <job-id> | tail -100
```

### Step 4: Diagnose

For each failure, categorize:

| Type | Examples | Action |
|------|----------|--------|
| **Test failure** | assertion error, spec fail | Read test + source, fix code or test |
| **Lint/style** | rubocop, eslint, prettier | Auto-fix or apply style changes |
| **Build error** | compile error, missing dep | Fix code or update dependencies |
| **Type error** | TypeScript, mypy | Fix type annotations or logic |
| **Flaky/infra** | timeout, network error | Re-run check, not a code issue |

Present the diagnosis to the user:

```
## CI Failures

| # | Check | Type | Error | Fix |
|---|-------|------|-------|-----|
| 1 | unit_tests chunk 10-12 | Test failure | NotNull assertion on move_in_date | Fix migration/model |
| 2 | Rubocop | Lint | Style/FrozenStringLiteral | Add frozen_string_literal comment |
| 3 | Team A Gate | Gate | Requires approval | Not a code issue — needs team review |
```

Ask: **"Fix all code issues? (all / specific numbers / skip)"**

### Step 5: Apply fixes

For each selected fix:

1. **Read** the failing test/lint rule and the source code it references
2. **Understand** the root cause — not just the symptom
3. **Apply** the minimal fix
4. **Run locally** if possible — `bundle exec rspec <file>`, `npm test`, `rubocop -a`, etc.
5. **Verify** the fix addresses the CI error

### Step 6: Push

```bash
git add -A && git commit -m "fix: resolve CI failures — [brief summary]"
git push
```

**Important**: Follow Conventional Commits. Do NOT include `Co-Authored-By` trailers.

Ask user to confirm before pushing.

### Step 7: Verify

After pushing, check if CI passes:

```bash
gh pr checks <number> --watch
```

Or suggest the user monitor the PR checks page.

### Step 8: Summary

```
## CI Fix Summary

### Fixed
| # | Check | Error | Fix applied |
|---|-------|-------|-------------|
| 1 | unit_tests | NotNull assertion | Added move_in_date to migration |
| 2 | Rubocop | FrozenStringLiteral | Added magic comment |

### Not fixable (manual action needed)
| # | Check | Reason |
|---|-------|--------|
| 3 | Team A Gate | Requires team approval |

### Skipped
| # | Check | Reason |
|---|-------|--------|
| 4 | ... | Flaky test — re-run suggested |

**Status**: Pushed fix commit. Waiting for CI re-run.
```

## Limitations

- Requires `gh` CLI with access to the repository
- Cannot re-run checks automatically — suggests user trigger re-run for flaky tests
- Gate checks (team approvals, deploy gates) cannot be fixed with code changes
- Very large CI logs may need manual investigation — skill reads last 100 lines per job
