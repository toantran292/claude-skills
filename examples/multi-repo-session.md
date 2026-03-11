# Example: Multi-Repo Session

Two complete examples of using the toolkit for a feature spanning multiple services.

---

## Example A: Orchestration (recommended)

### Task

Add user notification preferences across 3 services:
- `api-service` — REST API, owns user data
- `worker-service` — async job processing, consumes events
- `notification-service` — sends emails and SMS

### Step 1: Analyze all services

```
> /analyze-codebase api-service, worker-service, notification-service

# Codebase Analysis

## api-service
- Stack: NestJS + Prisma + PostgreSQL
- Entry Points: 24 REST endpoints, 1 cron job
- Owns: users, payments tables
- Publishes: UserCreated, UserUpdated events to Redis

## worker-service
- Stack: Node.js + Bull + Redis
- Entry Points: 8 queue consumers
- Subscribes: UserCreated, UserUpdated from api-service
- Owns: job_logs table

## notification-service
- Stack: NestJS + Nodemailer + Twilio
- Entry Points: 3 queue consumers (email, sms, push)
- Owns: notification_logs table
- Consumes: SendNotification jobs from worker-service

## Cross-Repo Dependency Map
| Source | Target | Contract | Risk |
|--------|--------|----------|------|
| api-service | worker-service | Redis events (UserCreated, UserUpdated) | Medium — no schema validation |
| worker-service | notification-service | Bull queue (SendNotification) | Low — shared job types |

## Integration Risks
- No formal schema validation between api-service → worker-service events
- Event field naming: api-service uses camelCase, worker-service mixes camelCase and snake_case
```

### Step 2: Design the cross-service feature

```
> /design-feature add notification preferences that users configure via API and all services respect

# Feature Design: Notification Preferences

## Feature Overview
- Goal: Users control which notification channels they receive (email, SMS, push)
- Trigger: User updates preferences via api-service REST endpoint
- Scope: Preferences stored in api-service, enforced in notification-service

## Architecture Flow
1. User calls PUT /api/v1/users/:id/preferences in api-service →
2. api-service persists to notification_preferences table →
3. api-service publishes PreferenceUpdated event to Redis →
4. worker-service consumes event, caches preferences in Redis →
5. When sending notification, worker-service checks cached preferences →
6. notification-service receives only opted-in channel jobs

## Cross-Service Contracts
| Contract | Provider | Consumer | Shape |
|----------|----------|----------|-------|
| GET /users/:id/preferences | api-service | worker-service | `{ email: boolean, sms: boolean, push: boolean }` |
| PreferenceUpdated event | api-service | worker-service | `{ userId: string, preferences: { email, sms, push } }` |
| SendNotification job | worker-service | notification-service | `{ userId, channel, payload }` (unchanged) |

## Implementation Strategy
| Phase | Service | What | Why This Order |
|-------|---------|------|----------------|
| 1 | api-service | Migration + CRUD + event publishing | Provider first |
| 2 | worker-service | Consume event + cache + filter | Consumer of api-service |
| 3 | notification-service | No changes needed | Already receives filtered jobs |

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Event field naming mismatch | High | Runtime failures | Define schema now, validate with /integration-check |
| Cache stale after preference update | Medium | Wrong channel used | TTL on cache + event-driven invalidation |
| Partial deployment | Medium | Inconsistent behavior | Deploy in order: api → worker → notification |

Save to .claude/designs/notification-preferences.md? [y]
> y
Saved.
```

### Step 3: Implement per repo

Each repo is opened in a separate Claude Code session.

**In api-service** (provider — implement first):
```
> /implement-ticket add notification preferences CRUD endpoints and publish PreferenceUpdated events

Loaded design from .claude/designs/notification-preferences.md ✓

Step 1: Confirmed scope — CRUD + event publishing only (this repo)
Step 2: Scanned architecture — users module, Prisma, Redis publisher
Step 3: Plan — 5 files: migration, DTO, service, controller, event publisher
Step 4: Implemented all files
Step 5: Generated 8 tests (CRUD + event publishing + validation)
Step 6: Review — 0 Critical, 0 Major
Step 7: Created PR #42

# Summary
- 5 files changed (1 migration, 2 DTOs, 1 service, 1 controller)
- 8 tests added
- PR: https://github.com/org/api-service/pull/42
```

**In worker-service** (consumer — implement second):
```
> /implement-ticket consume PreferenceUpdated events from api-service and cache user preferences

Loaded design from .claude/designs/notification-preferences.md ✓

Step 1: Confirmed scope — event consumer + Redis cache + job filtering
Step 2: Scanned architecture — Bull consumers, Redis client
Step 3: Plan — 3 files: event handler, preference cache, job filter
Step 4: Implemented all files
Step 5: Generated 6 tests (event handling + caching + filtering)
Step 6: Review — 1 Major (using `user_id` instead of `userId` — mismatch with api-service)
Step 7: Fixed field naming to match api-service contract
Step 8: Created PR #18

# Summary
- 3 files changed
- 6 tests added, 1 Major fixed
- PR: https://github.com/org/worker-service/pull/18
```

**In notification-service** (no changes needed per design):
```
> /implement-ticket check if notification-service needs changes for user preferences

Loaded design from .claude/designs/notification-preferences.md ✓

Analysis: notification-service receives SendNotification jobs from worker-service.
The job contract `{ userId, channel, payload }` is unchanged.
Worker-service now filters jobs before sending — notification-service needs no changes.

No implementation needed for this repo.
```

### Step 4: Validate integration

```
> /integration-check api-service worker-service notification-service

## API Contracts
| Endpoint | Provider | Consumer | Status |
|----------|----------|----------|--------|
| GET /users/:id/preferences | api-service | worker-service | ✓ Match |

## Event Schemas
| Event | Publisher | Subscriber | Status |
|-------|-----------|------------|--------|
| PreferenceUpdated | api-service | worker-service | ✓ Match |
| SendNotification | worker-service | notification-service | ✓ Match (unchanged) |

## Naming Consistency
| Concept | api-service | worker-service | notification-service | Status |
|---------|-------------|----------------|---------------------|--------|
| User ID field | userId | userId | userId | ✓ Consistent |
| Preferences shape | { email, sms, push } | { email, sms, push } | — | ✓ Consistent |

## Result: All checks pass ✓
```

### Step 5: Create PRs (already done per repo)

```
Deploy order:
1. api-service#42      — preferences CRUD + events
2. worker-service#18   — consume events + filter jobs
3. notification-service — no changes

Related PRs linked in each PR description.
```

---

## Example B: Manual step-by-step

### Same task, invoking each focused skill individually.

### Step 1: Scan each service

**In api-service:**
```
> /architecture-scan

## Modules: auth, users, notifications, payments
## Entry Points: 24 REST endpoints, 1 cron, Redis publisher
## Hot Spots: users.service.ts (high churn)
```

**In worker-service:**
```
> /architecture-scan

## Modules: events, jobs, cache
## Entry Points: 8 Bull queue consumers
## Hot Spots: event-handler.ts (no error handling for unknown events)
```

**In notification-service:**
```
> /architecture-scan

## Modules: email, sms, push
## Entry Points: 3 queue consumers
## Hot Spots: email.service.ts (200+ lines, no retry logic)
```

### Step 2: Plan per repo

**In api-service:**
```
> /implementation-plan add notification preferences CRUD and publish PreferenceUpdated events

## 5 files affected
## Order: migration → DTO → service → controller → event publisher
```

**In worker-service:**
```
> /implementation-plan consume PreferenceUpdated events and filter notification jobs by preference

## 3 files affected
## Order: event handler → preference cache → job filter
```

### Step 3: Implement (in order: api-service → worker-service)

Write code in each repo following the plan.

### Step 4: Test per repo

**In api-service:**
```
> /generate-tests
8 tests generated. All passing ✓
```

**In worker-service:**
```
> /generate-tests
6 tests generated. All passing ✓
```

### Step 5: Review per repo

**In api-service:**
```
> /review-branch
0 Critical, 0 Major. Production Readiness: 9/10. APPROVE ✓
```

**In worker-service:**
```
> /review-branch
1 Major: field naming mismatch (user_id vs userId)
Production Readiness: 6/10. REVISE.
```

### Step 6: Fix issues

**In worker-service:**
```
> /fix-branch rename user_id to userId to match api-service contract

Fixed: event-handler.ts, preference-cache.ts — renamed user_id → userId
```

### Step 7: Integration check

```
> /integration-check api-service worker-service notification-service

All contracts match ✓
```

### Step 8: Create PRs

**In api-service:**
```
> /create-pr
PR created: https://github.com/org/api-service/pull/42
```

**In worker-service:**
```
> /create-pr
PR created: https://github.com/org/worker-service/pull/18
```

Both PRs include:
```
Related PRs:
- api-service#42 (preferences CRUD + events)
- worker-service#18 (consume events + filter)

Deploy order: api-service → worker-service
```
