---
name: review-branch
description: Review code changes on a specific branch across multiple repos. Performs Staff/Principal Engineer level production code review, generates severity-ranked issues and SOLID/ACID fix plans.
argument-hint: "branch-name"
disable-model-invocation: true
---

# Branch Code Review - Staff/Principal Engineer Level

You are performing a rigorous production code review across multiple repositories for branch `$ARGUMENTS`.

## Step 0: Validate branch name

The branch to review is: **$ARGUMENTS**

If no branch name was provided, ask the user to provide one.

## Step 1: Load repo config and select repos

First, ensure the output directories exist:
```bash
mkdir -p ./claude-context/$ARGUMENTS
```

Always regenerate the repo config to keep it up to date:

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/generate-config.sh .
```

This script scans the current directory for git repos and detects tech stacks automatically.

Read the freshly generated config at `./claude-context/review-config.json`.

The config file format:
```json
{
  "repos": [
    { "name": "repo-name", "path": "./relative-or-absolute-path", "tech_stack": "Ruby + Sequel" }
  ],
  "default_tech_stack": "Auto-detected per repo",
  "deployment_env": "AWS ECS, RDS"
}
```

Present the list of repos to the user and ask which ones to review. The user can select one or more repos.

For each selected repo, verify the branch exists:
```bash
cd <repo-path> && git branch -a | grep "$ARGUMENTS"
```

If the branch doesn't exist in a repo, skip it and inform the user.

## Step 2: For each selected repo, gather the diff

For each repo where the branch exists:

1. Determine the base branch (usually `main` or `master`):
```bash
cd <repo-path> && git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main"
```

2. Get the full diff of the branch vs base:
```bash
cd <repo-path> && git diff origin/<base-branch>...origin/$ARGUMENTS
```

3. Get the list of changed files:
```bash
cd <repo-path> && git diff --name-only origin/<base-branch>...origin/$ARGUMENTS
```

4. Get commit log for the branch:
```bash
cd <repo-path> && git log --oneline origin/<base-branch>..origin/$ARGUMENTS
```

## Step 3: Perform the review

For each repo, review ALL changes with the following checklist. Be thorough and critical - you DID NOT write this code.

**Context assumptions:**
- Production system, high reliability, multi-tenant, handles PII
- Scale: 10,000+ requests/hour, expected to grow
- Deployment: Use `deployment_env` from config (default: AWS ECS, RDS)
- Tech stack: Use `default_tech_stack` from config per repo, or detect from the codebase

**Review categories:**

### 1. COMPLETENESS
- Does this fully implement the original requirement?
- Missing edge cases? Missing validation?
- Partial flows not handled? Failure states not handled?

### 2. CORRECTNESS
- Logical bugs? Race conditions? Concurrency issues?
- Idempotency problems? Transaction boundary issues?
- Timezone/date bugs? Nil/null handling?

### 3. SIDE EFFECTS
- Unintentional effect on other modules?
- Shared state mutation? Thread safety?
- Global config mutations? Memory leaks?
- Unbounded growth (arrays, logs, retries)?

### 4. SECURITY
- Injection risks (SQL, command, HTML)?
- PII exposure? Authorization gaps?
- Multi-tenant isolation? Replay attacks?
- Token handling? Rate limiting?

### 5. PERFORMANCE
- N+1 queries? Missing indexes?
- Inefficient loops? Blocking I/O?
- Large object loading? Missing pagination?
- Memory spikes? Hot path risks?

### 6. DATABASE
- Proper indexes? Transaction usage?
- Lock contention risk? Migration rollback safety?
- Backward compatibility? Zero-downtime safe?

### 7. API DESIGN
- Idempotent where needed? Proper status codes?
- Retry-safe? Timeout safe? Backward compatible?

### 8. TESTING GAPS
- Missing unit/integration/concurrency/failure/edge case tests?

### 9. OBSERVABILITY
- Sufficient logging? Structured logs?
- Sensitive data redacted? Metrics? Alertable failures?

### 10. PRODUCTION READINESS
- What breaks at 10x traffic?
- What breaks at 100 concurrent requests?
- What breaks under partial outage?
- What if Redis/Postgres is slow?

**Adversarial assumptions - review again under these:**
- Adversarial users and malicious traffic
- Frontend makes duplicate concurrent requests
- Retries happen
- Infrastructure partial failure
- Another developer misuses this API later

## Step 4: Generate output

Create the output directory:
```bash
mkdir -p ./claude-context/$ARGUMENTS
```

### 4a. Review file: `./claude-context/$ARGUMENTS/review.md`

For each repo, produce:

1. **Severity-ranked issue list:**
   - 🔴 Critical (must fix before prod)
   - 🟠 High
   - 🟡 Medium
   - 🔵 Low

2. **For each issue:**
   - WHY it is a problem
   - Example scenario
   - Concrete fix (code-level suggestion)

3. **Summary:**
   - Overall production readiness score (1–10)
   - Whether you would approve this PR
   - What must be fixed before merge

### 4b. Fix plan file: `./claude-context/$ARGUMENTS/fix-plan.md`

Generate a detailed fix plan that follows SOLID and ACID principles:

**SOLID compliance for each fix:**
- **S**ingle Responsibility: Each fix should address one concern
- **O**pen/Closed: Fixes should extend behavior, not modify existing contracts
- **L**iskov Substitution: Fixes must not break existing interfaces
- **I**nterface Segregation: Don't force unnecessary dependencies
- **D**ependency Inversion: Depend on abstractions, not concretions

**ACID compliance for database-related fixes:**
- **A**tomicity: Each fix must be all-or-nothing
- **C**onsistency: Fixes must maintain data integrity invariants
- **I**solation: Concurrent execution must not cause conflicts
- **D**urability: Changes must persist correctly after commit

The fix plan format:
```markdown
# Fix Plan for branch: <branch-name>

## Priority Order (fix in this sequence)

### Fix 1: [Title] - 🔴 Critical
- **Repo:** <repo-name>
- **Files:** <list of files to modify>
- **Problem:** <description>
- **SOLID principle:** <which principle this fix follows>
- **ACID compliance:** <if DB related, which properties are ensured>
- **Steps:**
  1. <concrete step with code>
  2. <concrete step with code>
- **Verification:** <how to verify the fix works>
- **Rollback plan:** <how to undo if something goes wrong>

### Fix 2: ...
```

After writing both files, inform the user:
- Where the files were saved
- Summary of critical/high issues count per repo
- Overall recommendation (approve/request changes)