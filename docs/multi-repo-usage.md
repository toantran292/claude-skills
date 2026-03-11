# Multi-Repo Usage

Workflow for implementing one task across multiple repositories.

## When to use

- Microservice architectures where a feature spans multiple services
- Monorepos with independent modules
- Shared library updates that affect downstream consumers
- API changes between producer and consumer services

## Using orchestration skills

### Analyze all services at once

```
/analyze-codebase api-service, worker-service, notification-service
```

Produces per-repo summaries plus a cross-repo dependency map with integration risks.

### Design a cross-service feature

```
/design-feature add real-time notification preferences across api, worker, and notification services
```

Produces system design with cross-service contracts, deployment order, and integration risks.

### Implement per repo

`/design-feature` saves its output to `.claude/design.md`. When you open each repo and run `/implement-ticket`, it reads the saved design file automatically — even in a new conversation.

Open each repo and run `/implement-ticket` with a scoped description:

**In api-service:**
```
/implement-ticket add notification preferences CRUD and publish PreferenceUpdated events
```

**In worker-service:**
```
/implement-ticket consume PreferenceUpdated events from api-service
```

**In notification-service:**
```
/implement-ticket respect user preferences when sending notifications
```

Each `/implement-ticket` runs the full cycle (scan → plan → implement → test → review → fix → PR) within that repo. Then validate integration across repos with `/integration-check`.

## Manual workflow (focused skills)

For maximum control, invoke focused skills in sequence:

### 1. Clarify the task

Understand:
- Which repositories are involved?
- What is the dependency order?
- Are there shared contracts (APIs, events, schemas)?

### 2. System architecture scan

Run `/architecture-scan` in each repo to understand:
- How services communicate
- Shared contracts and schemas
- Database ownership per service

### 3. Plan per repository

Run `/implementation-plan` for each repo. Key considerations:
- **Shared contracts first** — define API specs, event schemas, shared types
- **Providers before consumers** — implement the API before the client
- **Data before code** — run migrations before deploying new code

### 4. Implement per repository

Follow this order:
1. Shared libraries and contracts
2. Database migrations
3. Backend services (providers first)
4. Frontend / consumer services

### 5. Review per repository

Run `/review-branch` on each repo independently.

### 6. Integration check

```
/integration-check service-api service-worker service-notifications
```

Validates:
- API request/response schemas match between producer and consumer
- Event payloads match between publisher and subscriber
- Naming is consistent across services
- Dependency versions are compatible

### 7. Remediate (if needed)

Run `/remediation-plan` for issues found in reviews or integration check.

### 8. Fix per repository

Run `/fix-branch` in each affected repo.

### 9. Final validation

Re-run `/integration-check` to confirm all mismatches are resolved.

### 10. Pull requests

Create PRs per repo. Link related PRs in descriptions:
```
Related PRs:
- service-api#123 (API changes)
- service-worker#456 (consumer updates)
```

## Example: Adding user notifications

**Services**: `api-service`, `worker-service`, `notification-service`

Open each repo in turn and run the relevant skill:

**Step 1 — Scan** (in each repo):
```
/architecture-scan
```

**Step 2 — Plan** (in each repo):
```
/implementation-plan add notification preferences endpoint
```

**Step 3 — Implement** in order: api → worker → notification

**Step 4 — Test** (in each repo):
```
/generate-tests
```

**Step 5 — Review** (in each repo):
```
/review-branch
```

**Step 6 — Check integration** (from any repo, pass all paths):
```
/integration-check api-service worker-service notification-service
```

**Step 7 — Fix any issues, create PRs** (in each repo):
```
/fix-branch
/create-pr
```

## Common risks and mitigations

| Risk | Mitigation |
|------|------------|
| Schema drift | Define contracts before implementation. Use `/integration-check`. |
| Event contract mismatch | Version events. Check schemas across publisher/subscriber. |
| Naming inconsistency | Standardize in shared contracts. Check with `/integration-check`. |
| Missing dependency | Deploy in order: shared libs → data → providers → consumers. |
| Migration ordering | Run migrations before deploying code that depends on new columns. |
