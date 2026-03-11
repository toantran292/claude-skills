# Single-Repo Usage

Complete guide for using the Claude Skills Toolkit inside a single repository.

## Overview

The toolkit supports two approaches:
1. **One-command** — `/implement-ticket` runs the full cycle automatically
2. **Manual step-by-step** — invoke focused skills individually for maximum control

Both follow the same 11-step workflow. The one-command approach automates it; the manual approach gives you control at each step.

## The 11-Step Workflow

```
 1. Clarify        Confirm requirements and scope
 2. Scan           Understand codebase architecture
 3. Plan           Produce implementation plan
 4. Implement      Write the code
 5. Test           Generate tests for changed code
 6. Review         Get severity-ranked code review
 7. Remediate      Plan fixes for issues found
 8. Fix            Apply targeted fixes
 9. PR             Create pull request
10. Feedback       Address reviewer comments
11. QA             Fix bugs found in testing
```

## One-Command Workflow

For most tasks, use the orchestration skill:

```
/implement-ticket add user notification preferences with email and Slack channels
```

### What happens

1. **Clarify** — Claude confirms requirements and acceptance criteria with you
2. **Scan** — runs `/architecture-scan` to map affected modules and patterns
3. **Plan** — runs `/implementation-plan` to produce a concrete plan with files, order, risks
4. **Implement** — writes code following the plan, applying `.claude/rules/review.md` standards
5. **Test** — runs `/generate-tests` to write tests (happy path, edge cases, error cases)
6. **Review** — runs `/review-branch` for severity-ranked review
7. **Fix** — if Critical or Major issues found, runs `/remediation-plan` + `/fix-branch`
8. **PR** — runs `/create-pr` to push and create a pull request
9. **Summary** — presents changes made, tests added, review result, and PR URL

### Design context (optional)

If you designed the feature first with `/design-feature`, the design is saved to `.claude/designs/<feature-slug>.md`. `/implement-ticket` reads it automatically — even in a new conversation — and skips redundant analysis.

```
# Session 1: Design
/design-feature add notification preferences

# Session 2 (new conversation): Implement
/implement-ticket add notification preferences
# → automatically finds and uses the saved design
```

### Example output

```
# Implementation Summary: Email Notification Preferences

## Changes Made
| File | Change | Description |
|------|--------|-------------|
| prisma/migrations/001_preferences.sql | new | Add notification_preferences table |
| src/preferences/preferences.dto.ts | new | CreatePreference and UpdatePreference DTOs |
| src/preferences/preferences.service.ts | new | CRUD operations for preferences |
| src/preferences/preferences.controller.ts | new | REST endpoints: GET, PUT /preferences |
| src/notifications/notifications.service.ts | modify | Check preferences before sending |

## Tests Added
| Test | Covers |
|------|--------|
| preferences.service.spec.ts | CRUD operations, validation, edge cases |
| preferences.controller.spec.ts | Endpoint responses, auth, error handling |
| notifications.service.spec.ts | Preference enforcement on all send paths |

## Review Result
- Issues found: 1 Major (missing check on batch send path)
- Issues fixed: 1
- Remaining: 0

## Pull Request
- URL: https://github.com/org/api-service/pull/42
- Status: Ready for review
```

## Manual Step-by-Step Workflow

For maximum control, invoke each skill individually.

### Step 1: Clarify the task

Before any skill, make sure requirements are clear:
- What exactly needs to change?
- What are the acceptance criteria?
- Are there constraints (backward compatibility, performance, security)?

### Step 2: Scan architecture

```
/architecture-scan
```

**What it produces**: Module map, dependencies, integration points, hot spots, and risks.

**When to skip**: Trivial changes (typos, config). You already know the codebase well.

**Example output**:
```
## Modules
| Module | Responsibility | Dependencies |
|--------|---------------|-------------|
| auth   | Authentication | prisma, jwt |
| users  | User management | prisma, auth |
| notifications | Email sending | mailer, users |

## Hot Spots
| File | Concern |
|------|---------|
| users.service.ts | High churn, 4 PRs this week |
| notifications.service.ts | No tests, 200+ lines |
```

### Step 3: Create implementation plan

```
/implementation-plan add user notification preferences with email and Slack channels
```

**What it produces**: Affected files, implementation order, detailed steps, risks, validation checklist.

**When to skip**: Very small changes where the plan is obvious.

**Example output**:
```
## Affected Modules
| Module | Change | Files |
|--------|--------|-------|
| prisma | new migration | prisma/migrations/001_preferences.sql |
| users  | new endpoints | preferences.controller.ts, preferences.service.ts |
| notifications | modify | notifications.service.ts |

## Implementation Order
| # | Step | Reason |
|---|------|--------|
| 1 | Database migration | Schema must exist before code references it |
| 2 | DTOs and service | Business logic before controller |
| 3 | Controller + routes | Depends on service |
| 4 | Modify notification service | Depends on preferences model |

## Risks
| Risk | Mitigation |
|------|------------|
| Missing preference check on batch send | Audit all send() callers |
| Migration fails on existing data | Add default values |
```

### Step 4: Implement

Write the code following the plan. Claude Code applies standards from `.claude/rules/review.md` automatically (SOLID, Clean Code, Security, Performance).

### Step 5: Generate tests

```
/generate-tests
```

**What it produces**: Test files covering happy path, edge cases, and error cases. Follows your project's existing test patterns (framework, location, naming, mocking style).

**Input options**:
- No argument — tests changed files on the current branch
- File path — tests a specific file
- Module name — tests all files in a module

**Example output**:
```
## Tests Generated
| File | Tests | Covers |
|------|-------|--------|
| preferences.service.spec.ts | 5 | CRUD operations, validation |
| preferences.controller.spec.ts | 3 | Endpoints, auth, errors |

All tests passing: ✓
```

### Step 6: Review

```
/review-branch
```

**What it produces**: Severity-ranked review following `.claude/output-styles/review-report.md` format.

**Severity levels**:
- **Critical** — must fix before production (security holes, data loss, crashes)
- **Major** — should fix before merge (bugs, performance, missing validation)
- **Minor** — fix when convenient (style, naming, minor improvements)
- **Suggestions** — optional improvements (alternative approaches, nice-to-haves)

**Example output**:
```
## Critical (1)
1. **SQL injection in search query** — preferences.service.ts:42
   Raw user input concatenated into query string.
   Fix: Use parameterized query.

## Major (1)
1. **Missing preference check on batch send** — notifications.service.ts:89
   batchSend() bypasses preference lookup.
   Fix: Add preference check before each send in the batch loop.

## Production Readiness: 6/10
## Verdict: REVISE — fix Critical and Major issues before merge
```

### Step 7: Remediate (if issues found)

```
/remediation-plan from last review
```

**What it produces**: Prioritized fix plan with strategy, validation steps, and risk assessment.

**When to skip**: No Critical or Major issues in review. Or you know exactly what to fix.

### Step 8: Fix

```
/fix-branch
```

**What it produces**: Code changes that resolve the issues. Reads the remediation plan (or review, or any fix source) and applies minimal fixes.

**Input options**:
- No argument — uses the most recent review or remediation plan
- `from last review` — explicitly uses the last review
- PR number — reads PR review comments
- Description — direct fix instructions

```
/fix-branch                              # from last review/remediation
/fix-branch fix the SQL injection in preferences search
/fix-branch from PR 42                   # from PR review comments
```

### Step 9: Create PR

```
/create-pr
```

**What it produces**: A pull request with:
- Descriptive title (auto-generated from commits or provided)
- Structured body: summary, changes, test plan, risks
- Pushed branch

**Requires**: `gh` CLI authenticated with repository access.

### Step 10: Address feedback

```
/address-feedback 42
```

After reviewers leave comments on your PR, this skill:
1. Reads all review comments via `gh` CLI
2. Categorizes: must-fix, should-fix, optional, questions
3. Presents the list for your selection
4. Applies fixes one by one
5. Pushes with Conventional Commits

**Input options**:
```
/address-feedback 42               # Read PR #42 comments
/address-feedback from QA           # Apply QA bug fixes (paste or describe)
/address-feedback [paste comments]  # Direct feedback text
```

### Step 11: Fix CI (if needed)

```
/fix-ci 42
```

If CI checks fail after pushing:
1. Reads check statuses via `gh pr checks`
2. Fetches failed check logs via `gh run view --log-failed`
3. Diagnoses: test failure, lint, build error, type error, or flaky/infra
4. Fixes code issues and pushes
5. Reports what was fixed vs what needs manual action (e.g., approval gates)

## Quick Workflow

For small changes (bug fixes, config, typos) — skip the planning:

```
[make your changes]
/review-branch                     # Quick review
[fix anything Critical/Major]
/create-pr                         # Ship it
```

## Understanding a New Codebase

```
/analyze-codebase
```

Produces a comprehensive overview:
- Repository metadata (stack, structure, size)
- Core modules with responsibilities and dependencies
- Entry points (APIs, jobs, CLI, event handlers)
- Complexity areas with risk assessment

Great for onboarding or before starting a large unfamiliar task.

## Design Before Implementing

```
/design-feature add real-time notification system with email, SMS, and push
```

Produces a system design proposal:
- Architecture flow (data path through the system)
- Affected modules (new, modified, unchanged)
- Implementation strategy (phased, with ordering rationale)
- Risks with mitigations
- Validation strategy

Saved to `.claude/designs/<feature-slug>.md`. `/implement-ticket` reads it automatically in future conversations.

## Prompt Enhancement

```
/enhance-prompt tạo api cho payment processing với stripe webhook
```

Transforms rough input (any language) into a clear, structured English prompt. Useful for crafting precise prompts for Claude Code or any LLM.

## When to Skip Steps

| Change type | Skip | Go straight to |
|------------|------|----------------|
| Typo, config change | Scan, Plan, Test | Implement → Review → PR |
| Bug fix (known root cause) | Scan, Plan | Implement → Test → Review → PR |
| Already reviewed | Review, Remediate, Fix | PR |
| No issues in review | Remediate, Fix | PR |
| No test changes needed | Test | Review |

## Tips

- **Always review before PR**: even quick changes benefit from `/review-branch`
- **Use design for complex features**: `/design-feature` saves time by catching issues before code
- **Let implement-ticket handle it**: for standard tasks, the one-command approach covers everything
- **Fix CI early**: `/fix-ci` catches issues before reviewers see red checks
- **Init rules once**: run `init-rules.sh` in each project so skills have full context
