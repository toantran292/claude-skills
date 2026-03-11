---
name: review-branch
description: Review code changes on the current branch. Produces a structured review report with severity-ranked issues.
argument-hint: "branch-name (optional, defaults to current branch)"
---

# Review Branch

Perform a Staff/Principal Engineer level code review on the specified branch.

## Input

Branch to review: **$ARGUMENTS**

If no branch name provided, use the current branch. If on main/master, ask the user which branch to review.

## Process

### Step 1: Gather context

1. Determine base branch:
```bash
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main"
```

2. Get the diff, changed files, and commit log:
```bash
git diff origin/<base>...<branch>
git diff --name-only origin/<base>...<branch>
git log --oneline origin/<base>..<branch>
```

3. Identify the tech stack from project files (package.json, Gemfile, go.mod, requirements.txt, etc.).

### Step 2: Review

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

### Step 3: Output

Use the format from `.claude/output-styles/review-report.md`.

Write the report to stdout. Include:
- Severity-ranked issues (Critical, Major, Minor, Suggestions)
- For each issue: what, why, example scenario, concrete fix suggestion
- Production readiness score (1-10)
- Whether you would approve the PR
- Open questions for the author
