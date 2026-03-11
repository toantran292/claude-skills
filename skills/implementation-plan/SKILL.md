---
name: implementation-plan
description: Generate a concrete implementation plan with affected files, order, risks, and validation checklist.
argument-hint: "the task or feature to plan"
---

# Implementation Plan

Produce a concrete, actionable implementation plan for the given task.

## Input

The task is: **$ARGUMENTS**

If no task was provided, ask the user to describe what they want to implement.

## Process

### Step 1: Understand scope

- What exactly needs to change?
- What are the acceptance criteria?
- Are there constraints (backward compatibility, performance, timeline)?

If the task is ambiguous, ask clarifying questions before planning.

### Step 2: Scan the codebase

Run an architecture scan (or use one from context) to understand:
- Which modules are affected
- What patterns exist in the codebase
- What dependencies are involved

### Step 3: Produce the plan

```
## Implementation Plan: [Task Title]

### Affected Modules
| Module/File | Change Type | Description |
|-------------|-------------|-------------|
| ...         | new/modify  | ...         |

### Implementation Order
1. [First change — why it goes first]
2. [Second change — depends on #1]
3. ...

### Detailed Steps
#### Step 1: [Title]
- Files: [list]
- Changes: [what to do]
- Tests: [what to test]

#### Step 2: ...

### Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| ...  | ...    | ...        |

### Validation Checklist
- [ ] [requirement 1 met]
- [ ] [tests pass]
- [ ] [no regressions]
- [ ] [backward compatible]
```

### Step 4: Review the plan

Before presenting, verify:
- Is the order correct? (dependencies before dependents)
- Are all affected files listed?
- Are risks realistic, not generic?
- Is the validation checklist specific to this task?
