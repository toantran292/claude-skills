# Architecture

## Design philosophy

This toolkit follows Claude Code's architecture model: small, focused components that compose together.

- **Skills** are the primary interface. Each skill does one thing and produces a defined output.
- **Rules** are shared standards extracted from skills to avoid duplication.
- **Agents** define specialized roles with clear boundaries.
- **Output styles** standardize artifact formats so skills produce consistent outputs.
- **Hooks** enable automation around skill execution.

## Component relationships

```
User invokes a skill
    ↓
Skill references rules (standards, workflows)
    ↓
Skill references output styles (format templates)
    ↓
Skill may delegate to agents (specialized roles)
    ↓
Hooks fire after skill execution (automation)
```

## Directory layout

```
.
├── CLAUDE.md                  # Project conventions (loaded by Claude Code)
├── skills/                    # User-invocable skills
│   └── <skill-name>/SKILL.md
├── agents/                    # Subagent role definitions
│   └── <role>.md
├── hooks/                     # Example automation scripts
│   └── <event>.example.sh
├── output-styles/             # Reusable output format templates
│   └── <artifact>.md
├── .claude/rules/             # Shared standards and workflows
│   └── <topic>.md
├── docs/                      # Documentation
├── examples/                  # Example outputs
└── scripts/                   # Install, relink, validate
```

## Key design decisions

### Rules extraction

Previous skills (review-branch, fix-branch, execute-prompt) each contained 50-100 lines of duplicated engineering standards (SOLID, Clean Code, Security, Performance). These are now extracted to `.claude/rules/review.md` and referenced by skills with one line.

### No workflow skills

The previous version had `workflow-*` skills that orchestrated other skills. These are replaced by documented workflows in `.claude/rules/single-repo-workflow.md` and `.claude/rules/multi-repo-workflow.md`. Users follow the workflow by invoking skills in sequence, which is more flexible and debuggable than skill-calling-skill chains.

### Single-repo as default

Skills default to working with the current repository and branch. Multi-repo support is available through `/integration-check` and the multi-repo workflow guide, but is not forced on single-repo users.

### Output to stdout

Skills output to stdout rather than writing to files (the previous version wrote to `./claude-context/`). This is simpler, more composable, and follows Claude Code conventions. Users can save outputs using hooks or manually.

## Skill dependency graph

```
enhance-prompt          (standalone — no dependencies)
architecture-scan       (standalone — no dependencies)
implementation-plan     (benefits from architecture-scan output)
review-branch           (standalone — references rules/review.md)
remediation-plan        (takes review-branch output as input)
fix-branch              (takes remediation-plan or review output as input)
integration-check       (standalone — multi-repo focused)
create-skill            (standalone — meta skill)
```
