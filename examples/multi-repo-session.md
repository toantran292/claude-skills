# Example: Multi-Repo Session

Example of using the toolkit for a feature spanning multiple services.

---

## Task

Add user notification preferences across 3 services: `api-service` (REST API), `worker-service` (async jobs), `notification-service` (sends emails/SMS).

## Session

### Step 1: Scan each service

```
> cd api-service && /architecture-scan
Stack: NestJS + Prisma + PostgreSQL
Owns: users, preferences tables
Publishes: PreferenceUpdated event to Redis

> cd worker-service && /architecture-scan
Stack: Node.js + Bull + Redis
Subscribes: PreferenceUpdated event
Publishes: SendNotification job

> cd notification-service && /architecture-scan
Stack: NestJS + Nodemailer + Twilio
Subscribes: SendNotification job
Owns: notification_logs table
```

### Step 2: Plan per repo

```
> cd api-service && /implementation-plan add notification preferences CRUD and publish events

> cd worker-service && /implementation-plan consume PreferenceUpdated events and filter notifications

> cd notification-service && /implementation-plan respect user preferences when sending
```

### Step 3: Implement

Implement in order:
1. `api-service` — DB migration, CRUD endpoints, event publishing
2. `worker-service` — event consumer, preference-aware filtering
3. `notification-service` — check preferences before send

### Step 4: Review each

```
> cd api-service && /review-branch
> cd worker-service && /review-branch
> cd notification-service && /review-branch
```

### Step 5: Integration check

```
> /integration-check api-service worker-service notification-service

## Integration Check Report

### Event Schemas
| Publisher | Subscriber | Event | Status | Issues |
|-----------|------------|-------|--------|--------|
| api-service | worker-service | PreferenceUpdated | MISMATCH | api uses `userId`, worker expects `user_id` |

### Naming Inconsistencies
| Concept | api-service | worker-service | Recommendation |
|---------|-------------|----------------|---------------|
| user ID field | userId | user_id | Standardize to userId (matches API convention) |
```

### Step 6: Fix the mismatch

```
> cd worker-service && /fix-branch
# Fix: rename user_id to userId in event consumer
```

### Step 7: Re-check integration

```
> /integration-check api-service worker-service notification-service
# All checks pass
```

### Step 8: Create PRs

```
api-service#42 — feat: add notification preferences CRUD
worker-service#18 — feat: consume preference events
notification-service#7 — feat: respect user preferences

Each PR links to the related PRs in the description.
Deploy order: api-service → worker-service → notification-service
```
