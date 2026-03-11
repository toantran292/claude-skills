---
name: architecture-scan
description: Analyze repository architecture — modules, dependencies, integration points, and likely affected areas.
argument-hint: "path or description of what to scan"
---

# Architecture Scan

Analyze the codebase to understand its architecture before making changes.

## Input

Scan target: **$ARGUMENTS**

If no input provided, scan the current repository root.

## Process

### Step 1: Discover structure

Identify:
- **Language and framework** from manifest files (package.json, Gemfile, go.mod, etc.)
- **Entry points** (main files, route definitions, app bootstrap)
- **Module boundaries** (directories, packages, namespaces)
- **Data layer** (models, migrations, schemas)
- **External dependencies** (APIs, databases, queues, caches)
- **Configuration** (env files, config objects, feature flags)
- **Test structure** (test directories, test framework, coverage config)

### Step 2: Map dependencies

For each major module:
- What does it depend on?
- What depends on it?
- What are the integration points (shared types, API calls, events, DB tables)?

### Step 3: Identify hot spots

- Files with the most recent changes (likely active development)
- Large files or modules (complexity risk)
- Circular dependencies
- Tightly coupled modules

### Step 4: Output

Present a structured architecture summary:

```
## Architecture Summary

**Stack**: [language, framework, DB, etc.]
**Structure**: [monolith/microservice/monorepo]

### Modules
| Module | Purpose | Dependencies | Dependents |
|--------|---------|-------------|------------|
| ...    | ...     | ...         | ...        |

### Integration Points
- [list of APIs, events, shared schemas]

### Hot Spots
- [files/modules likely affected by changes]

### Risks
- [architectural concerns, tight coupling, missing boundaries]
```

For multi-repo scans, repeat per repository and add a cross-repo dependency map.
