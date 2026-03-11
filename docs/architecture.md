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

## Skill layers

Skills are organized in two layers:

### Orchestration skills

High-level skills that coordinate focused skills into complete workflows. These do not duplicate logic — they sequence, gate, and summarize.

| Skill | Orchestrates |
|-------|-------------|
| `analyze-codebase` | `architecture-scan`, `integration-check` (multi-repo) |
| `design-feature` | `architecture-scan`, `integration-check` (multi-repo) |
| `implement-ticket` | `architecture-scan` → `implementation-plan` → [implement] → `generate-tests` → `review-branch` → `remediation-plan` → `fix-branch` → `integration-check` (multi-repo) → `create-pr` |
| `address-feedback` | reads PR/QA feedback → categorizes → applies fixes via `fix-branch` approach → pushes |

### Focused skills

Single-responsibility skills that do one thing well. Orchestration skills delegate to these.

| Skill | Responsibility |
|-------|---------------|
| `architecture-scan` | Map codebase structure and dependencies |
| `implementation-plan` | Produce concrete plan with files, order, risks |
| `review-branch` | Severity-ranked code review |
| `remediation-plan` | Convert review into prioritized fix plan |
| `fix-branch` | Apply targeted fixes from any source |
| `generate-tests` | Write tests for changed or untested code |
| `create-pr` | Create PR with structured description and test plan |
| `integration-check` | Cross-repo consistency validation |
| `enhance-prompt` | Prompt transformation |
| `create-skill` | Scaffold new skills |

## Key design decisions

### Rules extraction

Previous skills (review-branch, fix-branch, execute-prompt) each contained 50-100 lines of duplicated engineering standards (SOLID, Clean Code, Security, Performance). These are now extracted to `.claude/rules/review.md` and referenced by skills with one line.

### Orchestration over monoliths

The previous version had `workflow-*` skills with `disable-model-invocation: true` that were opaque chains. The new orchestration skills (`analyze-codebase`, `design-feature`, `implement-ticket`, `address-feedback`) improve on this by:
- Clearly delegating to focused skills (no logic duplication)
- Including user confirmation gates between phases
- Supporting both single-repo and multi-repo modes
- Producing structured output artifacts

Users can also invoke focused skills directly for fine-grained control.

### Single-repo as default

Skills default to working with the current repository and branch. Multi-repo support is available through `/integration-check`, `/analyze-codebase` (multi-path mode), and the multi-repo workflow guide.

### Output to stdout

Skills output to stdout rather than writing to files (the previous version wrote to `./claude-context/`). This is simpler, more composable, and follows Claude Code conventions. Users can save outputs using hooks or manually.

## Skill dependency graph

```
Orchestration layer:
  analyze-codebase ──→ architecture-scan, integration-check
  design-feature ────→ architecture-scan, integration-check
  implement-ticket ──→ architecture-scan → implementation-plan
                       → [implement] → generate-tests
                       → review-branch → remediation-plan → fix-branch
                       → integration-check (multi-repo)
                       → create-pr
  address-feedback ──→ reads PR/QA feedback → fix-branch approach → push

Focused layer:
  enhance-prompt          (standalone — no dependencies)
  architecture-scan       (standalone — no dependencies)
  implementation-plan     (benefits from architecture-scan output)
  review-branch           (standalone — references rules/review.md)
  remediation-plan        (takes review-branch output as input)
  fix-branch              (takes any fix source as input)
  generate-tests          (standalone — tests changed files on branch)
  create-pr               (standalone — creates PR from branch)
  integration-check       (standalone — multi-repo focused)
  create-skill            (standalone — meta skill)
```
