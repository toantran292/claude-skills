# Example: Multi-Repo Session

Examples of using the toolkit for a feature spanning multiple services.

---

## Example A: Using orchestration skills (recommended)

### Task

Add user notification preferences across 3 services: `api-service` (REST API), `worker-service` (async jobs), `notification-service` (sends emails/SMS).

### Step 1: Analyze all services

```
> /analyze-codebase api-service, worker-service, notification-service

# Codebase Analysis

## api-service
- Stack: NestJS + Prisma + PostgreSQL
- Entry Points: 24 REST endpoints
- Owns: users, payments tables

## worker-service
- Stack: Node.js + Bull + Redis
- Entry Points: 8 queue consumers
- Subscribes: events from api-service

## notification-service
- Stack: NestJS + Nodemailer + Twilio
- Entry Points: 3 queue consumers
- Owns: notification_logs table

## Cross-Repo Map
| Source | Target | Contract Type | Risk |
|--------|--------|--------------|------|
| api-service | worker-service | Redis events | Medium — no schema validation |
| worker-service | notification-service | Bull queue | Low — shared job types |
```

### Step 2: Design the cross-service feature

```
> /design-feature add notification preferences that users configure via API and all channels respect

# Feature Design: Notification Preferences

## Architecture Flow
1. User configures preferences via api-service PUT /preferences →
2. api-service publishes PreferenceUpdated event →
3. worker-service caches preferences, filters outgoing notifications →
4. notification-service checks preferences before each send

## Cross-Service Contracts
| Contract | Provider | Consumer | Shape |
|----------|----------|----------|-------|
| GET /users/:id/preferences | api-service | worker-service | { email: bool, sms: bool } |
| PreferenceUpdated event | api-service | worker-service | { userId, preferences } |

## Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| Event field naming mismatch | Runtime failure | Define schema first, validate with /integration-check |
```

### Step 3: Implement per repo

```
> cd api-service && /implement-ticket add notification preferences CRUD and publish PreferenceUpdated event
[scan → plan → implement → review → fix → done]

> cd worker-service && /implement-ticket consume PreferenceUpdated events and filter notifications
[scan → plan → implement → review → fix → done]

> cd notification-service && /implement-ticket check user preferences before sending
[scan → plan → implement → review → fix → done]
```

### Step 4: Validate integration

```
> /integration-check api-service worker-service notification-service

### Event Schemas
| Publisher | Subscriber | Event | Status | Issues |
|-----------|------------|-------|--------|--------|
| api-service | worker-service | PreferenceUpdated | MISMATCH | api uses `userId`, worker expects `user_id` |

> cd worker-service && /fix-branch
# Fix: rename user_id to userId

> /integration-check api-service worker-service notification-service
# All checks pass
```

### Step 5: Create PRs

```
api-service#42 — feat: add notification preferences CRUD
worker-service#18 — feat: consume preference events
notification-service#7 — feat: respect user preferences

Deploy order: api-service → worker-service → notification-service
```

---

## Example B: Using focused skills (manual control)

### Same task, invoking each skill individually:

```
# 1. Scan each service
cd api-service && /architecture-scan
cd worker-service && /architecture-scan
cd notification-service && /architecture-scan

# 2. Plan per repo
cd api-service && /implementation-plan add notification preferences endpoint
cd worker-service && /implementation-plan consume notification preferences events
cd notification-service && /implementation-plan send notifications via user preferences

# 3. Implement in order: api → worker → notification

# 4. Review each
cd api-service && /review-branch
cd worker-service && /review-branch
cd notification-service && /review-branch

# 5. Check integration
/integration-check api-service worker-service notification-service

# 6. Fix mismatches, re-check, create PRs
```
