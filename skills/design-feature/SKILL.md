---
name: design-feature
description: Transform a feature request into a system design proposal with architecture flow, affected modules, and risks.
argument-hint: "feature description (e.g. 'Add Zillow lead ingestion support')"
---

# Design Feature

Turn a feature request into a structured system design — before any code is written.

## Input

Feature request: **$ARGUMENTS**

If no description provided, ask the user to describe the feature.

## Process

### Step 1: Clarify requirements

Before designing, confirm understanding:
- What is the user-facing behavior?
- What triggers this feature (API call, event, scheduled job, UI action)?
- What are the inputs and expected outputs?
- Are there constraints (latency, data volume, compliance)?

Ask clarifying questions if the request is ambiguous. Do not proceed until the scope is clear.

### Step 2: Analyze current architecture

Run the equivalent of `/architecture-scan` to understand:
- Which modules exist and what they do
- How data flows through the system
- What patterns the codebase already uses
- What integration points are available

### Step 3: Design the feature

Produce the design. Focus on system-level decisions, not code:

- **Data flow** — how data enters, transforms, and persists
- **Module ownership** — which module handles which responsibility
- **New vs modified** — what's new, what changes, what stays the same
- **Integration points** — APIs, events, or shared state between modules

### Step 4: Multi-repo considerations

If the feature spans multiple services:
- Map which repo owns which part of the feature
- Define the contracts between services (API shapes, event schemas)
- Identify deployment ordering
- Flag potential integration risks

Use the analysis approach from `/integration-check` to validate contracts.

### Step 5: Risk assessment

Identify:
- Technical risks (new technology, complex migrations, performance unknowns)
- Integration risks (breaking changes, contract mismatches)
- Scope risks (feature creep, unclear requirements)
- Assumptions that need validation

## Output

```
# Feature Design: [Feature Name]

## Feature Overview
- **Goal**: [one sentence]
- **Trigger**: [what initiates this feature]
- **Scope**: [bounded description of what's included and excluded]

## Architecture Flow
[Step-by-step description of how data flows through the system]

1. [trigger] →
2. [module A processes] →
3. [module B persists] →
4. [module C notifies]

## Affected Modules
| Module | Change Type | Description |
|--------|-------------|-------------|
| ...    | new/modify/none | ... |

## Implementation Strategy
| Phase | What | Why This Order |
|-------|------|---------------|
| 1     | ...  | [dependency reason] |
| 2     | ...  | ...                 |

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| ...  | Low/Med/High | ... | ... |

## Validation Strategy
- [ ] [how to verify the feature works end-to-end]
- [ ] [how to verify no regressions]
- [ ] [how to verify cross-service contracts]

## Cross-Service Contracts (multi-repo only)
| Contract | Provider | Consumer | Shape |
|----------|----------|----------|-------|
| ...      | ...      | ...      | [brief schema] |
```

## Persistence

After presenting the design, save it to `.claude/designs/<feature-slug>.md` (e.g. `.claude/designs/notification-preferences.md`).

Ask the user: **"Save this design to `.claude/designs/<feature-slug>.md`?"**

`/implement-ticket` looks in `.claude/designs/` for matching design files. Multiple designs can coexist for parallel work.

## Limitations

- This skill produces design, not code — use `/implementation-plan` for detailed steps
- Design is based on current architecture; does not account for planned refactors unless stated
- Cross-repo designs require all repos to be locally available for scanning
