# Example: Single-Repo Session

Example of using the toolkit for a feature in a single repository.

---

## Task

Add email notification preferences to a NestJS API service.

## Session

### Step 1: Scan

```
> /architecture-scan

## Architecture Summary

**Stack**: Node.js + NestJS + Prisma + PostgreSQL
**Structure**: Modular monolith

### Modules
| Module | Purpose | Dependencies | Dependents |
|--------|---------|-------------|------------|
| auth   | Authentication | prisma, jwt | users, payments |
| users  | User management | prisma, auth | notifications |
| notifications | Email sending | mailer, users | — |
| payments | Payment processing | prisma, stripe | — |

### Integration Points
- REST API endpoints under /api/v1
- Prisma ORM for database access
- Bull queue for async email sending

### Hot Spots
- src/users/users.service.ts (most recent changes)
- src/notifications/ (new module, minimal tests)
```

### Step 2: Plan

```
> /implementation-plan add email notification preferences per user

## Implementation Plan: Email Notification Preferences

### Affected Modules
| Module/File | Change Type | Description |
|-------------|-------------|-------------|
| prisma/schema.prisma | modify | Add NotificationPreference model |
| prisma/migrations/ | new | Create notification_preferences table |
| src/users/dto/ | new | Add preference DTOs |
| src/users/users.controller.ts | modify | Add preference endpoints |
| src/users/users.service.ts | modify | Add preference CRUD |
| src/notifications/notifications.service.ts | modify | Check preferences before sending |

### Implementation Order
1. Database migration (schema first)
2. DTOs and validation
3. Service layer (CRUD for preferences)
4. Controller endpoints
5. Update notification service to check preferences
6. Tests
```

### Step 3: Implement

[Write the code following the plan]

### Step 4: Review

```
> /review-branch

# Review Report: feat/notification-preferences
...
2 Major issues, 1 Minor issue found
Production Readiness: 7/10
```

### Step 5: Remediate and fix

```
> /remediation-plan from last review
> /fix-branch
```

### Step 6: Final review

```
> /review-branch

Production Readiness: 9/10
Verdict: APPROVE
```

### Step 7: PR

Create the pull request and merge.
