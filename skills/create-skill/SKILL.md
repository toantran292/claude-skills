---
name: create-skill
description: Scaffold a new skill aligned with this toolkit's conventions.
argument-hint: "description of the skill you want to create"
---

# Create Skill

Scaffold a new Claude Code skill for this toolkit.

## Input

The skill idea is: **$ARGUMENTS**

If no description was provided, ask the user to describe what skill they want.

## Process

### Step 1: Classify and name

Determine:
- **Name**: kebab-case `<verb>-<noun>` pattern (e.g. `lint-code`, `generate-tests`)

Present the proposed name to the user for confirmation.

### Step 2: Scaffold SKILL.md

Create `skills/<skill-name>/SKILL.md` with this structure:

```markdown
---
name: <skill-name>
description: <one-line description>
argument-hint: "<example argument>"
---

# <Title>

<Brief description.>

## Input

The input is: **$ARGUMENTS**

If no input was provided, ask the user to provide one.

## Process

### Step 1: ...

### Step 2: ...

## Output

<Describe the expected output.>
```

Follow conventions from `.claude/rules/repository-structure.md`:
- Reference shared rules instead of embedding large instruction blocks
- Reference output styles where applicable
- Keep instructions concise and actionable

### Step 3: Update README

Add the new skill to the Skills table in `README.md`, sorted alphabetically.

### Step 4: Relink

```bash
bash scripts/relink.sh
```

### Step 5: Verify

Show the created SKILL.md and confirm it's available for use.
