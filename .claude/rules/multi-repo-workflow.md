# Multi-Repo Workflow

Workflow for implementing a task across multiple repositories (microservices, monorepo modules, etc.).

## Steps

1. **Clarify** — Understand the task and which repositories are involved.
2. **System scan** — Run `/architecture-scan` across each repo to understand the system topology, shared contracts, and integration points.
3. **Plan per repo** — Run `/implementation-plan` for each repo. Identify cross-repo dependencies and ordering.
4. **Implement per repo** — Implement changes repo by repo, starting with shared contracts (schemas, APIs, events).
5. **Review per repo** — Run `/review-branch` on each repo.
6. **Integration check** — Run `/integration-check` to validate cross-repo consistency (API contracts, event schemas, naming).
7. **Remediate** (if needed) — Run `/remediation-plan` for issues found.
8. **Fix** — Run `/fix-branch` per repo.
9. **Final validation** — Re-run `/integration-check`. Run end-to-end tests if available.
10. **PRs** — Create pull requests per repo, linking related PRs in descriptions.

## Implementation order

1. Shared libraries and contracts first
2. Data layer changes (migrations, schemas)
3. Backend services (API providers before consumers)
4. Frontend / consumer services last

## Common risks

- **Schema drift**: API producer and consumer disagree on field names, types, or required fields.
- **Event contract mismatch**: Event publisher and subscriber use different schemas.
- **Naming inconsistency**: Same concept named differently across repos.
- **Missing dependency**: Service A depends on Service B's new endpoint, but B hasn't been deployed.
- **Migration ordering**: DB migrations must run before code that depends on new columns.

## Mitigation

- Define contracts (OpenAPI, JSON Schema, protobuf) before implementation.
- Use `/integration-check` after implementation to catch mismatches.
- Deploy in dependency order: shared libs > data > providers > consumers.
