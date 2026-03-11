# Example: Single-Repo Session

Two complete examples of using the toolkit for a feature in a single repository.

---

## Example A: Orchestration (recommended)

### Task

Add email notification preferences to a NestJS API service — users can opt in/out of email and Slack notifications per channel.

### Step 1: Understand the codebase

```
> /analyze-codebase

# Codebase Analysis

## Repository Overview
- Name: api-service
- Stack: Node.js + NestJS + Prisma + PostgreSQL
- Structure: Modular monolith (4 modules)
- Test Framework: Jest

## Core Modules
| Module | Responsibility | Key Dependencies |
|--------|---------------|-----------------|
| auth   | Authentication + JWT | prisma, bcrypt, passport |
| users  | User management + profiles | prisma, auth |
| notifications | Email sending via queue | bull, mailer, users |
| payments | Payment processing | prisma, stripe |

## Entry Points
| Type | Path/Pattern | Count |
|------|-------------|-------|
| REST API | /api/v1/* | 24 endpoints |
| Bull Queue | notification.* consumers | 3 consumers |
| Cron | @Cron('0 9 * * 1') weekly digest | 1 job |

## Complexity Areas
| Area | Concern | Risk |
|------|---------|------|
| notifications module | No tests, 200+ line service | Regressions undetected |
| users.service.ts | 4 PRs this week, high churn | Merge conflicts |
| prisma schema | 12 models, no preference model yet | Migration needed |
```

### Step 2: Design the feature

```
> /design-feature add user email notification preferences with per-channel opt-in

# Feature Design: Email Notification Preferences

## Feature Overview
- Goal: Let users control which notification channels they receive
- Trigger: User updates preferences via REST API
- Scope: Email and Slack channels, per-user, stored in DB

## Architecture Flow
1. User submits preferences via PUT /api/v1/users/:id/preferences →
2. users module validates + persists to notification_preferences table →
3. notifications module reads preferences before each send →
4. Unsubscribed channels are skipped, subscribed channels proceed

## Affected Modules
| Module | Change Type | Description |
|--------|-------------|-------------|
| prisma | modify | Add NotificationPreference model |
| users  | modify | Add preferences CRUD endpoints |
| notifications | modify | Check preferences before sending |

## Implementation Strategy
| Phase | What | Why This Order |
|-------|------|----------------|
| 1 | Database migration | Schema must exist before code |
| 2 | DTO + service + controller | Business logic + API |
| 3 | Modify notification service | Depends on preferences model |

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Missing preference check on batch send | Medium | Users get unwanted email | Audit all send() callers |
| Migration fails on existing data | Low | Deploy blocked | Default values for existing rows |
| Performance on high-volume send | Low | Slow notifications | Index on userId in preferences table |

Save this design to .claude/designs/notification-preferences.md? [y]
> y
Saved.
```

### Step 3: Implement end-to-end

```
> /implement-ticket add email notification preferences per user

Step 1: Clarified requirements
  - Per-channel opt-in for email and Slack
  - Default: all channels enabled for new users
  - Acceptance: CRUD endpoints + enforcement on all send paths

Step 2: Loaded saved design from .claude/designs/notification-preferences.md ✓

Step 3: /architecture-scan — confirmed users + notifications modules, Prisma schema

Step 4: /implementation-plan
  - 6 files affected
  - Order: migration → DTO → service → controller → notification service update
  - Risk: batch send path bypass

Step 5: Implemented
  - prisma/migrations/20260311_add_notification_preferences.sql
  - src/preferences/dto/create-preference.dto.ts
  - src/preferences/dto/update-preference.dto.ts
  - src/preferences/preferences.service.ts
  - src/preferences/preferences.controller.ts
  - src/notifications/notifications.service.ts (modified)

Step 6: /generate-tests — 11 tests across 3 files
  - preferences.service.spec.ts: 5 tests (CRUD + validation + defaults)
  - preferences.controller.spec.ts: 3 tests (endpoints + auth + errors)
  - notifications.service.spec.ts: 3 tests (preference enforcement + batch send)
  All passing ✓

Step 7: /review-branch
  - 0 Critical
  - 1 Major: batch send path in notifications.service.ts bypasses preference check
  - 1 Minor: missing JSDoc on new controller
  - Production Readiness: 7/10

Step 8: /remediation-plan + /fix-branch
  - Fixed: added preference check in batchSend() method
  - Re-review: 0 Critical, 0 Major. Production Readiness: 9/10

Step 9: /create-pr — pushed branch, created PR #42

# Implementation Summary: Email Notification Preferences

## Changes Made
| File | Change | Description |
|------|--------|-------------|
| prisma/migrations/20260311_... | new | Add notification_preferences table |
| src/preferences/dto/*.ts | new | CreatePreference and UpdatePreference DTOs |
| src/preferences/preferences.service.ts | new | CRUD operations with validation |
| src/preferences/preferences.controller.ts | new | GET, PUT /api/v1/users/:id/preferences |
| src/notifications/notifications.service.ts | modify | Check preferences before send + batchSend |

## Tests Added
| Test File | Count | Covers |
|-----------|-------|--------|
| preferences.service.spec.ts | 5 | CRUD, validation, defaults |
| preferences.controller.spec.ts | 3 | Endpoints, auth, errors |
| notifications.service.spec.ts | 3 | Preference enforcement |

## Review Result
- Issues found: 1 Major, 1 Minor
- Issues fixed: 1 Major
- Remaining: 1 Minor (JSDoc — optional)

## Pull Request
- URL: https://github.com/org/api-service/pull/42
- Status: Ready for review
```

### Step 4: Address reviewer feedback

```
> /address-feedback 42

## Feedback Collected (3 items)

| # | Source | Category | Issue |
|---|--------|----------|-------|
| 1 | @senior-dev | Must fix | Add rate limiting to preferences endpoint |
| 2 | @senior-dev | Should fix | Use class-validator pipe instead of manual check |
| 3 | @teammate | Optional | Rename `prefs` to `preferences` for clarity |

Fix all? (all / specific numbers / skip)
> all

✓ #1: Added @Throttle(10, 60) to preferences controller
✓ #2: Replaced manual validation with ValidationPipe + class-validator decorators
✓ #3: Renamed `prefs` → `preferences` in service and tests

Committed: fix: address PR feedback — rate limiting, validation pipe, naming
Pushed to branch.
```

### Step 5: Fix CI (if needed)

```
> /fix-ci 42

## CI Checks
| # | Check | Status |
|---|-------|--------|
| 1 | unit_tests | ✓ Pass |
| 2 | lint | ✓ Pass |
| 3 | build | ✓ Pass |

All checks passing. No action needed.
```

---

## Example B: Manual step-by-step

### Same task, invoking each skill individually for maximum control.

### Step 1: Scan

```
> /architecture-scan

## Modules
| Module | Responsibility | Dependencies |
|--------|---------------|-------------|
| auth   | Authentication | prisma, jwt |
| users  | User management | prisma, auth |
| notifications | Email sending | mailer, users |
| payments | Payment processing | prisma, stripe |

## Hot Spots
| File | Concern |
|------|---------|
| users.service.ts | High churn (4 PRs this week) |
| notifications.service.ts | No tests, 200+ lines |
```

### Step 2: Plan

```
> /implementation-plan add email notification preferences per user

## Affected Modules
| Module | Change | Key Files |
|--------|--------|-----------|
| prisma | new migration | migrations/20260311_preferences.sql |
| users  | new CRUD | preferences.service.ts, preferences.controller.ts |
| notifications | modify | notifications.service.ts |

## Implementation Order
| # | Step | Depends On |
|---|------|-----------|
| 1 | Create migration | — |
| 2 | Create DTOs | — |
| 3 | Create preferences service | Migration |
| 4 | Create preferences controller | Service |
| 5 | Modify notification service | Preferences model |

## Risks
| Risk | Mitigation |
|------|------------|
| Batch send bypass | Audit all notification.send() callers |
| Migration on existing data | Default values for all rows |
```

### Step 3: Implement

Write the code following the plan. Claude Code applies `.claude/rules/review.md` standards automatically.

### Step 4: Generate tests

```
> /generate-tests

## Tests Generated
| File | Tests | Covers |
|------|-------|--------|
| preferences.service.spec.ts | 5 | CRUD operations, validation, defaults |
| preferences.controller.spec.ts | 3 | Endpoints, auth, error responses |
| notifications.service.spec.ts | 3 | Preference enforcement, batch send |

All tests passing: ✓
```

### Step 5: Review

```
> /review-branch

## Major (1)
1. Missing preference check on batch send — notifications.service.ts:89

## Minor (1)
1. Missing JSDoc on new controller methods

## Production Readiness: 7/10
## Verdict: REVISE — fix Major issue before merge
```

### Step 6: Remediate and fix

```
> /remediation-plan from last review

## P1 — Major
1. Add preference check in batchSend() before each notification
   File: notifications.service.ts:89
   Strategy: Call getPreferences(userId) and filter channels

> /fix-branch

✓ Fixed: Added preference check in batchSend()
Verified: batchSend now calls getPreferences() and filters unsubscribed channels
```

### Step 7: Final review

```
> /review-branch

## No Critical or Major issues
## Minor (1): JSDoc (unchanged from previous review)

## Production Readiness: 9/10
## Verdict: APPROVE
```

### Step 8: Create PR

```
> /create-pr

PR created: https://github.com/org/api-service/pull/42

## Summary
- Add notification preferences CRUD (GET/PUT /api/v1/users/:id/preferences)
- Enforce preferences on all notification send paths including batch

## Test Plan
- [x] CRUD operations (create, read, update)
- [x] Default preferences for new users
- [x] Preference enforcement on single send
- [x] Preference enforcement on batch send
- [x] Auth required for all endpoints
```

### Step 9: Address feedback

```
> /address-feedback 42

2 items from reviewer:
1. [Must fix] Add rate limiting to preferences endpoint
2. [Should fix] Use ValidationPipe instead of manual check

Fixed both. Pushed to branch.
```
