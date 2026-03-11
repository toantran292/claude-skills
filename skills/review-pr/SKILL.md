---
name: review-pr
description: Review code changes on a GitHub pull request using gh CLI.
argument-hint: "PR number (e.g. '42') or 'current' for current branch PR"
---

# Review PR

Perform a Staff/Principal Engineer level code review on a GitHub pull request.

## Input

PR: **$ARGUMENTS**

Accepts:
- **PR number** — reviews that specific PR
- **"current"** — finds the PR for the current branch
- **No input** — detects PR from current branch, or asks for a number

## Process

### Step 1: Identify the PR

```bash
# If no PR number provided, find from current branch
gh pr view --json number,title,headRefName,baseRefName,url,author,body,additions,deletions,changedFiles 2>/dev/null
```

If no PR is found, ask the user for a PR number.

If a PR number is provided:
```bash
gh pr view <number> --json number,title,headRefName,baseRefName,url,author,body,additions,deletions,changedFiles
```

Display a brief summary: title, author, base ← head, +additions/-deletions, changed files count.

### Step 2: Get the diff and changed files

```bash
# Get the full diff
gh pr diff <number>

# Get list of changed files
gh pr diff <number> --name-only
```

### Step 3: Read related source files

For each changed file, if the diff alone is insufficient to understand the context:
- Read the full file to understand surrounding code
- Check imports, function signatures, and class definitions
- Look at tests related to changed code

Identify the tech stack from project files (package.json, Gemfile, go.mod, requirements.txt, etc.).

### Step 4: Check existing review comments

```bash
# Read existing review comments to avoid duplicating feedback
gh api repos/{owner}/{repo}/pulls/<number>/comments --jq '.[] | {path, line, body, user: .user.login}'

# Read general PR comments
gh pr view <number> --comments --json comments --jq '.comments[] | {author: .author.login, body}'
```

### Step 5: Review

Apply all standards from `.claude/rules/review.md`.

Review every changed file across these categories:

1. **Completeness** — Does it fully implement the requirement? Missing edge cases?
2. **Correctness** — Logic bugs, race conditions, null handling, transaction boundaries?
3. **Side effects** — Unintended impact on other modules? Shared state mutation?
4. **Security** — Injection risks, PII exposure, auth gaps, input validation?
5. **Performance** — N+1 queries, missing indexes, unbounded results, memory?
6. **Database** — Indexes, transactions, migration safety, backward compatibility?
7. **API design** — Idempotent? Proper status codes? Backward compatible?
8. **Testing gaps** — Missing tests for critical paths?
9. **Observability** — Logging, metrics, error visibility?
10. **Production readiness** — What breaks at 10x traffic? Under partial outage?

### Step 6: Output

Use the format from `.claude/output-styles/review-report.md`.

Adapt the header for PR context:

```
**PR**: #[number] [title]
**Author**: [author]
**Branch**: [head] → [base]
**URL**: [url]
```

Write the report to stdout. Include:
- Severity-ranked issues (Critical, Major, Minor, Suggestions)
- For each issue: what, why, example scenario, concrete fix suggestion
- Production readiness score (1-10)
- Whether you would approve the PR
- Open questions for the author

### Step 7: Optionally post review to GitHub

Ask the user: **"Post this review as a GitHub PR review? (yes / no)"**

If yes:
```bash
# Post as a PR review comment
gh pr review <number> --comment --body "<review summary>"
```

For inline comments on specific files/lines, use:
```bash
gh api repos/{owner}/{repo}/pulls/<number>/reviews --method POST --field body="<summary>" --field event="COMMENT" --field comments='[{"path":"<file>","line":<line>,"body":"<comment>"}]'
```

## Limitations

- Requires `gh` CLI with access to the repository
- Very large PRs (500+ changed files) may need to be reviewed in chunks
- Cannot run the code — review is static analysis only
- Inline GitHub review comments require appropriate repository permissions
