# Repository Structure Rules

## Skill structure

Each skill lives in `skills/<skill-name>/SKILL.md`.

SKILL.md format:
```yaml
---
name: skill-name
description: One-line description
argument-hint: "example argument"
---
```

Followed by markdown with: Input, Process (numbered steps), Output.

## Naming

- Skills: `<verb>-<noun>` in kebab-case (e.g. `review-branch`)
- Agents: `<role>.md` in kebab-case (e.g. `code-reviewer.md`)
- Output styles: `<artifact-name>.md` (e.g. `review-report.md`)
- Hook examples: `<event>.example.sh` (e.g. `after-review.example.sh`)
- Rules: `<topic>.md` (e.g. `review.md`)

## Composition

- Skills reference rules via: "Apply standards from `.claude/rules/review.md`"
- Skills reference output styles via: "Use the format from `.claude/output-styles/review-report.md`"
- Skills do NOT embed large instruction blocks — they reference shared files
- Agents define role boundaries and tool preferences

## Variables

- `$ARGUMENTS` — user input passed to the skill
- Agents and hooks do not use `$ARGUMENTS`
