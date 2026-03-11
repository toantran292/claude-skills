---
name: create-pr
description: Create a pull request with structured description, test plan, and linked context.
argument-hint: "PR title or description (optional, auto-generated from commits)"
---

# Create PR

Create a well-structured pull request from the current branch.

## Input

PR context: **$ARGUMENTS**

If no input provided, generate title and description from commit history and diff.

## Process

### Step 1: Gather context

1. Current branch and base branch:
```bash
git branch --show-current
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main"
```

2. Commits on this branch:
```bash
git log --oneline origin/<base>..HEAD
```

3. Changed files and diff summary:
```bash
git diff --stat origin/<base>...HEAD
```

4. Check if branch is pushed:
```bash
git log origin/<branch>..HEAD 2>/dev/null
```

### Step 2: Generate PR content

Compose a PR with:

- **Title**: concise (< 70 chars), follows repo commit conventions if any
- **Summary**: what changed and why (2-5 bullets)
- **Changes**: list of affected modules/files grouped by concern
- **Test plan**: how to verify the changes (automated + manual steps)
- **Risks**: anything the reviewer should watch for
- **Related**: link tickets, issues, or related PRs if mentioned in commits or arguments

### Step 3: Push and create

1. Push the branch if not already pushed:
```bash
git push -u origin <branch>
```

2. Create the PR:
```bash
gh pr create --title "<title>" --body "<body>"
```

3. If `gh` is not available, output the PR description for manual creation.

### Step 4: Present

Show the PR URL and description to the user.

## Output

```
## Pull Request Created

**URL**: <pr-url>
**Title**: <title>
**Base**: <base> ← <branch>

### Description
[the PR body that was submitted]
```

## Limitations

- Requires `gh` CLI for automated PR creation; falls back to manual output
- Does not assign reviewers — user should configure via GitHub settings or add manually
- Does not link to external ticket systems (Jira, Linear) unless URLs are in commit messages
