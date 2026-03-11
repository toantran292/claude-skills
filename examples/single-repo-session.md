# Example: Single-Repo Session

Examples of using the toolkit for a feature in a single repository.

---

## Example A: Using orchestration skills (recommended)

### Task

Add email notification preferences to a NestJS API service.

### Step 1: Understand the codebase

```
> /analyze-codebase

# Codebase Analysis

## Repository Overview
- Name: api-service
- Stack: Node.js + NestJS + Prisma + PostgreSQL
- Structure: Modular monolith
- Size: Medium (4 modules)

## Core Modules
| Module | Responsibility | Key Dependencies |
|--------|---------------|-----------------|
| auth   | Authentication | prisma, jwt |
| users  | User management | prisma, auth |
| notifications | Email sending | mailer, users |
| payments | Payment processing | prisma, stripe |

## Entry Points
| Type | Path/Name | Description |
|------|-----------|-------------|
| API  | /api/v1/* | 24 REST endpoints |
| Job  | Bull queue consumers | Async email sending |

## Complexity Areas
| Area | Concern | Impact |
|------|---------|--------|
| notifications | New module, minimal tests | Regressions may go undetected |
| users.service | High churn, most recent changes | Risk of merge conflicts |
```

### Step 2: Design the feature

```
> /design-feature add user email notification preferences with per-channel opt-in

# Feature Design: Email Notification Preferences

## Architecture Flow
1. User submits preferences via PUT /api/v1/users/:id/preferences →
2. users module validates + persists to notification_preferences table →
3. notifications module reads preferences before each send →
4. Unsubscribed channels are skipped

## Affected Modules
| Module | Change Type | Description |
|--------|-------------|-------------|
| users  | modify | Add preferences CRUD endpoints |
| notifications | modify | Check preferences before sending |
| prisma | modify | Add NotificationPreference model |

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Preferences not checked on all send paths | Medium | Users receive unwanted email | Audit all notification.send() callers |
```

### Step 3: Implement end-to-end

```
> /implement-ticket add email notification preferences per user

Step 1: Clarified requirements — per-channel opt-in for email and Slack
Step 2: /architecture-scan — mapped users + notifications modules
Step 3: /implementation-plan — 6 files affected, migration-first order
Step 4: Implemented migration, DTOs, service, controller
Step 5: /generate-tests — 8 tests (CRUD + preference enforcement)
Step 6: /review-branch — 1 Major issue (missing preference check on batch send)
Step 7: /remediation-plan + /fix-branch — fixed batch send path
Step 8: /create-pr — pushed branch, created PR #42
Step 9: Summary:

# Implementation Summary: Email Notification Preferences
## Changes Made: 6 files (1 migration, 2 DTOs, 2 service updates, 1 controller)
## Tests Added: 8 tests (CRUD + preference enforcement)
## Review Result: 1 Major fixed, 0 remaining
## Pull Request: https://github.com/org/api-service/pull/42
```

### Step 4: Address reviewer feedback

```
> /address-feedback 42

## Feedback Collected (3 items)
1. [Must fix] Add rate limiting to preferences endpoint
2. [Should fix] Use DTO validation pipe instead of manual check
3. [Optional] Rename `prefs` to `preferences` for clarity

> all

Fixed 3 items. Pushed to branch.
```

---

## Example B: Using focused skills (manual control)

### Task

Same feature, invoking each skill individually.

### Step 1: Scan

```
> /architecture-scan
[architecture summary output]
```

### Step 2: Plan

```
> /implementation-plan add email notification preferences per user
[implementation plan output]
```

### Step 3: Implement

[Write the code following the plan]

### Step 4: Review

```
> /review-branch
2 Major issues, 1 Minor issue found
Production Readiness: 7/10
```

### Step 5: Generate tests

```
> /generate-tests
## Tests Generated
- preferences.service.spec.ts: 5 tests (CRUD + validation)
- preferences.controller.spec.ts: 3 tests (endpoints)
All tests passing: yes
```

### Step 6: Remediate and fix

```
> /remediation-plan from last review
> /fix-branch
```

### Step 7: Final review

```
> /review-branch
Production Readiness: 9/10
Verdict: APPROVE
```

### Step 8: Create PR

```
> /create-pr
PR created: https://github.com/org/api-service/pull/42
```

### Step 9: Address feedback

```
> /address-feedback 42
2 items from reviewer. Fixed and pushed.
```
