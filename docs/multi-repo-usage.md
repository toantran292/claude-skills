# Multi-Repo Usage

Complete guide for implementing a task across multiple repositories (microservices, monorepo modules, shared libraries).

## When to Use

- Feature spans multiple services (e.g., API + worker + notification)
- Shared library update affects downstream consumers
- API change requires coordinated producer + consumer updates
- Event schema change needs publisher + subscriber alignment
- Database migration affects multiple services

## Key Concepts

### Implementation order matters

```
1. Shared libraries and contracts (schemas, types, events)
2. Database migrations
3. Backend providers (the service that exposes the API/event)
4. Backend consumers (the service that calls the API/listens to events)
5. Frontend / client services
```

Always: **providers before consumers**, **data before code**, **contracts before implementation**.

### Design persists across conversations

`/design-feature` saves its output to `.claude/designs/<feature-slug>.md`. When you open each repo and run `/implement-ticket`, it reads the saved design automatically — even in a new Claude Code conversation.

### Each repo gets its own Claude Code session

Multi-repo workflow means: open each repo separately in Claude Code and run skills there. Do NOT `cd` into other repos within a session — skills reference `.claude/rules/` relative to the current project.

## Approach 1: Orchestration (Recommended)

### Step 1: Analyze all services

From any repo (or the parent directory containing all service repos):

```
/analyze-codebase api-service, worker-service, notification-service
```

**Produces**:
- Per-repo summary (stack, modules, entry points)
- Cross-repo dependency map
- Integration risks (no schema validation, shared state, etc.)

### Step 2: Design the cross-service feature

```
/design-feature add notification preferences that users configure via API and all services respect
```

**Produces**:
- Architecture flow across all services
- Module ownership per service
- Cross-service contracts (API schemas, event payloads)
- Deployment order
- Risks with mitigations

The design is saved to `.claude/designs/notification-preferences.md`.

### Step 3: Implement per repo

Open each repo in a separate Claude Code session. `/implement-ticket` reads the saved design file automatically.

**In api-service** (the provider — implement first):
```
/implement-ticket add notification preferences CRUD endpoints and publish PreferenceUpdated events
```

This runs the full cycle within api-service: scan → plan → implement → test → review → fix → PR.

**In worker-service** (the consumer — implement second):
```
/implement-ticket consume PreferenceUpdated events from api-service and cache user preferences
```

**In notification-service** (the consumer — implement last):
```
/implement-ticket check user notification preferences before sending emails and SMS
```

Each `/implement-ticket` uses the saved design context to understand the full system design, even though it only implements the portion relevant to that repo.

### Step 4: Validate integration

From any repo that has access to all service directories:

```
/integration-check api-service worker-service notification-service
```

**Validates**:
- API request/response schemas match between producer and consumer
- Event payloads match between publisher and subscriber
- Field naming is consistent across services
- Dependency versions are compatible

**Example output**:
```
## API Contracts
| Endpoint | Provider | Consumer | Status |
|----------|----------|----------|--------|
| GET /users/:id/preferences | api-service | worker-service | ✓ Match |
| PUT /users/:id/preferences | api-service | frontend | ✓ Match |

## Event Schemas
| Event | Publisher | Subscriber | Status | Issue |
|-------|-----------|------------|--------|-------|
| PreferenceUpdated | api-service | worker-service | MISMATCH | api uses `userId`, worker expects `user_id` |

## Recommendation
Fix 1 event schema mismatch before deploying.
```

### Step 5: Fix mismatches

Open the affected repo and fix:

**In worker-service**:
```
/fix-branch rename user_id to userId in PreferenceUpdated event handler to match api-service schema
```

### Step 6: Re-validate

```
/integration-check api-service worker-service notification-service
```

Confirm all checks pass.

### Step 7: Create PRs

In each repo:
```
/create-pr
```

Link related PRs in descriptions:
```
Related PRs:
- api-service#42 (preferences CRUD + events)
- worker-service#18 (consume preference events)
- notification-service#7 (respect user preferences)

Deploy order: api-service → worker-service → notification-service
```

## Approach 2: Manual Step-by-Step

For maximum control, invoke focused skills individually in each repo.

### Step 1: Clarify the task

Before starting, understand:
- Which repositories are involved?
- What is the dependency order? (Which repo provides, which consumes?)
- Are there shared contracts (APIs, events, schemas)?

### Step 2: Scan each repo

Open each repo and run:

```
/architecture-scan
```

Understand: how services communicate, shared contracts, database ownership per service.

### Step 3: Plan per repo

In each repo:

```
/implementation-plan add notification preferences endpoint
```

Key considerations:
- **Shared contracts first** — define API specs, event schemas, shared types before implementation
- **Providers before consumers** — implement the API before the client
- **Data before code** — run migrations before deploying new code

### Step 4: Implement per repo

Follow this order:
1. Shared libraries and contracts
2. Database migrations
3. Backend services (providers first)
4. Frontend / consumer services

### Step 5: Test per repo

In each repo:

```
/generate-tests
```

### Step 6: Review per repo

In each repo:

```
/review-branch
```

Fix any Critical or Major issues before proceeding.

### Step 7: Integration check

From any location with access to all repos:

```
/integration-check api-service worker-service notification-service
```

### Step 8: Fix mismatches

In each affected repo:

```
/remediation-plan [paste integration check findings]
/fix-branch
```

### Step 9: Re-validate

```
/integration-check api-service worker-service notification-service
```

### Step 10: Create PRs

In each repo:

```
/create-pr
```

Link related PRs in descriptions.

## Example: Adding User Notifications

**Services**: `api-service` (REST API), `worker-service` (async jobs), `notification-service` (sends emails/SMS)

### Phase 1: Understand and Design

```
/analyze-codebase api-service, worker-service, notification-service
/design-feature add notification preferences across all services
```

### Phase 2: Implement (in order)

**In api-service** (provider — first):
```
/implement-ticket add notification preferences CRUD and publish PreferenceUpdated events
```

**In worker-service** (consumer — second):
```
/implement-ticket consume PreferenceUpdated events and filter notifications by user preferences
```

**In notification-service** (consumer — last):
```
/implement-ticket respect user notification preferences before sending
```

### Phase 3: Validate and Ship

```
/integration-check api-service worker-service notification-service
```

Fix any mismatches, then create PRs in each repo.

### Deploy order

```
1. api-service      (new table + endpoints + events)
2. worker-service   (consumes new events)
3. notification-service  (reads new preferences)
```

## Common Risks and Mitigations

| Risk | What goes wrong | How to prevent |
|------|----------------|----------------|
| **Schema drift** | API producer returns `user_id`, consumer expects `userId` | Define contracts before implementation. Use `/integration-check` after. |
| **Event contract mismatch** | Publisher sends `{userId, prefs}`, subscriber expects `{user_id, preferences}` | Define event schema first. Version events. Check with `/integration-check`. |
| **Naming inconsistency** | `preferences` in one service, `notification_settings` in another | Agree on naming in the design phase. Check with `/integration-check`. |
| **Missing dependency** | Consumer deployed before provider's new endpoint exists | Deploy in dependency order: shared libs → data → providers → consumers. |
| **Migration ordering** | Code references a column that doesn't exist yet | Always deploy migrations before code that depends on new columns. |
| **Partial deployment** | Only 2 of 3 services deployed, system in inconsistent state | Deploy all related services together. Use feature flags if needed. |

## Tips

- **Design first**: `/design-feature` catches contract mismatches before any code is written
- **Provider before consumer**: always implement and deploy the provider service first
- **Check often**: run `/integration-check` after implementing each repo, not just at the end
- **Link PRs**: include related PRs and deploy order in every PR description
- **Init rules in each repo**: run `init-rules.sh` once per repo so skills have full context
- **One session per repo**: open each repo in its own Claude Code session
