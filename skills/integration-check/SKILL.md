---
name: integration-check
description: Validate cross-repository or cross-service consistency — API contracts, event schemas, naming, dependencies.
argument-hint: "list of repos or services to check"
---

# Integration Check

Validate consistency across repositories or services in a multi-repo system.

## Input

Services to check: **$ARGUMENTS**

If no input provided, scan the current directory for repositories (directories containing `.git`).

## Process

### Step 1: Discover services

For each repository/service, identify:
- API endpoints (routes, controllers, OpenAPI specs)
- Event publishers and subscribers (message queues, webhooks)
- Shared types and schemas (protobuf, JSON Schema, TypeScript interfaces)
- Database dependencies (which service owns which tables)
- Environment variables and configuration

### Step 2: Check API compatibility

For every API endpoint consumed by another service:
- Do request/response schemas match between producer and consumer?
- Are required fields present on both sides?
- Are field types compatible (string vs number, date format)?
- Are enum values consistent?
- Is the HTTP method and path correct?

### Step 3: Check event schemas

For every event published by one service and consumed by another:
- Does the event payload schema match?
- Are required fields present?
- Is the event name/topic consistent?
- Is versioning handled?

### Step 4: Check naming consistency

- Same concept should have the same name across repos (e.g. `user_id` vs `userId` vs `UserId`)
- Same enum values across services
- Consistent error code formats

### Step 5: Check dependency alignment

- Package versions: shared libraries at compatible versions?
- Database: migrations from service A compatible with service B's expectations?
- Environment: all required env vars documented and consistent?

### Step 6: Output

```
## Integration Check Report

### API Contracts
| Producer | Consumer | Endpoint | Status | Issues |
|----------|----------|----------|--------|--------|
| ...      | ...      | ...      | OK/MISMATCH | ... |

### Event Schemas
| Publisher | Subscriber | Event | Status | Issues |
|-----------|------------|-------|--------|--------|
| ...       | ...        | ...   | OK/MISMATCH | ... |

### Naming Inconsistencies
| Concept | Service A | Service B | Recommendation |
|---------|-----------|-----------|---------------|
| ...     | user_id   | userId    | Standardize to user_id |

### Dependency Issues
- [version mismatches, missing deps]

### Summary
- [total issues found]
- [critical mismatches that would cause runtime failures]
- [recommendations]
```
