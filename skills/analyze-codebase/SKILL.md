---
name: analyze-codebase
description: Understand a repository quickly — architecture, modules, integrations, entry points, and complexity areas.
argument-hint: "path to repo (optional, defaults to current directory)"
---

# Analyze Codebase

Produce a structured overview of a repository so developers can understand it quickly.

## Input

Target: **$ARGUMENTS**

If no path provided, analyze the current repository. For multi-repo analysis, accept a comma-separated list of paths.

## Process

### Step 1: Architecture scan

Run the equivalent of `/architecture-scan` on the target:
- Detect language, framework, and infrastructure from manifest files
- Map module boundaries, entry points, and data layer
- Identify external dependencies (APIs, DBs, queues, caches)
- Map inter-module dependencies

### Step 2: Identify entry points

Catalog how the system is accessed:
- **API endpoints** — REST routes, GraphQL resolvers, gRPC services
- **Background jobs** — workers, cron jobs, queue consumers
- **CLI commands** — scripts, rake tasks, management commands
- **Event handlers** — message subscribers, webhook receivers

### Step 3: Assess complexity

Identify high-risk areas without dumping file lists:
- Modules with the most cross-cutting dependencies
- Large files or functions (complexity hotspots)
- Areas with poor test coverage (test dirs vs source dirs)
- Recent churn (frequently changed files from git log)

### Step 4: Multi-repo (if multiple paths provided)

For each repo, produce its own summary. Then add:
- **Cross-repo dependency map** — which repo calls which
- **Shared contracts** — APIs, events, schemas between repos
- **Integration risks** — potential contract drift areas

Use the capabilities of `/integration-check` for cross-repo analysis.

## Output

```
# Codebase Analysis

## Repository Overview
- **Name**: [repo name]
- **Stack**: [language, framework, DB, infra]
- **Structure**: [monolith / microservice / monorepo]
- **Size**: [approximate — small/medium/large, module count]

## Architecture Summary
[2-3 sentence description of how the system is organized]

## Core Modules
| Module | Responsibility | Key Dependencies |
|--------|---------------|-----------------|
| ...    | ...           | ...             |

## External Integrations
| Integration | Type | Used By |
|-------------|------|---------|
| ...         | API/DB/Queue/Cache | ... |

## Entry Points
| Type | Path/Name | Description |
|------|-----------|-------------|
| API  | ...       | ...         |
| Job  | ...       | ...         |

## Complexity Areas
| Area | Concern | Impact |
|------|---------|--------|
| ...  | [why it's complex] | [what could go wrong] |

## Cross-Repo Map (multi-repo only)
| Source | Target | Contract Type | Risk |
|--------|--------|--------------|------|
| ...    | ...    | API/Event    | ...  |
```

## Limitations

- Does not read every file — samples structure and key files
- Complexity assessment is heuristic, not static analysis
- Multi-repo analysis requires all repos to be locally available
