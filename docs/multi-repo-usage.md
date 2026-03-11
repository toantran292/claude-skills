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

```
cd api-service && /implement-ticket add notification preferences CRUD and publish events
cd worker-service && /implement-ticket consume PreferenceUpdated events
cd notification-service && /implement-ticket respect user preferences when sending
```

Each `/implement-ticket` runs the full cycle (scan → plan → implement → review → fix) within that repo. Then validate integration across repos with `/integration-check`.

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

```
# 1. Scan each service
cd api-service && /architecture-scan
cd worker-service && /architecture-scan
cd notification-service && /architecture-scan

# 2. Plan
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

# 6. Fix any issues, create PRs
```

## Common risks and mitigations

| Risk | Mitigation |
|------|------------|
| Schema drift | Define contracts before implementation. Use `/integration-check`. |
| Event contract mismatch | Version events. Check schemas across publisher/subscriber. |
| Naming inconsistency | Standardize in shared contracts. Check with `/integration-check`. |
| Missing dependency | Deploy in order: shared libs → data → providers → consumers. |
| Migration ordering | Run migrations before deploying code that depends on new columns. |
