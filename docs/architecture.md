# Architecture

How the Claude Skills Toolkit is designed and why.

## Design Philosophy

This toolkit follows Claude Code's architecture model: **small, focused components that compose together**.

- **Skills** are the primary interface — each does one thing and produces a defined output
- **Rules** are shared standards extracted from skills — no duplication across skills
- **Agents** define specialized roles with clear boundaries and expertise
- **Output styles** standardize artifact formats so skills produce consistent, professional output
- **Hooks** enable automation around skill execution without modifying skills

## Component Relationships

```
┌──────────────────────────────────────────────────────────┐
│                     User                                 │
│              types /review-branch                        │
└─────────────────────┬────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────────────────┐
│                Claude Code                               │
│   Discovers skill in ~/.claude/skills/review-branch/     │
│   Loads SKILL.md                                         │
└─────────────────────┬────────────────────────────────────┘
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
   ┌────────────┐ ┌────────┐ ┌─────────┐
   │ .claude/   │ │output- │ │ agents/ │
   │ rules/     │ │styles/ │ │         │
   │            │ │        │ │         │
   │ review.md  │ │review- │ │code-    │
   │ prompts.md │ │report  │ │reviewer │
   │ ...        │ │.md     │ │.md      │
   └────────────┘ └────────┘ └─────────┘
        │                         │
        │   Standards to apply    │   Role to assume
        │   (SOLID, Security,     │   (Staff Engineer
        │    Performance, ...)    │    perspective)
        │                         │
        └────────┬────────────────┘
                 ▼
          ┌─────────────┐
          │   Output     │
          │   (stdout)   │
          └──────┬──────┘
                 ▼
          ┌─────────────┐
          │   Hooks      │    Optional automation
          │   (optional) │    (save to file, notify,
          └─────────────┘     run tests, etc.)
```

## Directory Layout

```
claude-skills/
├── CLAUDE.md                      Project conventions (loaded automatically by Claude Code)
│
├── skills/                        15 user-invocable skills
│   ├── implement-ticket/          Orchestration: end-to-end implementation
│   ├── analyze-codebase/          Orchestration: full codebase analysis
│   ├── design-feature/            Orchestration: feature → system design
│   ├── address-feedback/          Orchestration: PR/QA feedback → fixes
│   ├── architecture-scan/         Focused: map codebase structure
│   ├── implementation-plan/       Focused: concrete implementation plan
│   ├── review-branch/             Focused: severity-ranked code review
│   ├── remediation-plan/          Focused: review findings → fix plan
│   ├── fix-branch/                Focused: apply targeted fixes
│   ├── fix-ci/                    Focused: diagnose + fix CI failures
│   ├── generate-tests/            Focused: write tests for changed code
│   ├── create-pr/                 Focused: create structured PR
│   ├── integration-check/         Focused: cross-repo validation
│   ├── enhance-prompt/            Focused: prompt transformation
│   └── create-skill/              Focused: scaffold new skill
│
├── agents/                        5 specialized subagent definitions
│   ├── system-architect.md        Architecture analysis and planning
│   ├── code-reviewer.md           Staff-level code review
│   ├── code-fixer.md              Minimal, correct code fixes
│   ├── security-reviewer.md       OWASP, auth, data protection
│   └── prompt-engineer.md         Prompt crafting and optimization
│
├── hooks/                         4 example automation scripts
│   ├── README.md                  Setup instructions
│   ├── after-review.example.sh    Save review output
│   ├── after-fix.example.sh       Run tests after fixes
│   ├── notify.example.sh          Send notifications
│   └── protect-critical-files.example.sh  Block protected file edits
│
├── .claude/output-styles/                 3 standardized output formats
│   ├── review-report.md           Severity buckets + score + verdict
│   ├── fix-plan.md                Priority groups + validation
│   └── explanatory-dev.md         Lead-with-answer format
│
├── .claude/
│   └── rules/                     5 shared standards
│       ├── review.md              Code review: SOLID, Security, Performance, ACID
│       ├── prompts.md             Prompt engineering rules
│       ├── repository-structure.md  Naming and composition conventions
│       ├── single-repo-workflow.md  11-step single-repo workflow
│       └── multi-repo-workflow.md   10-step multi-repo workflow
│
├── docs/                          Documentation
│   ├── getting-started.md         Quick start guide
│   ├── architecture.md            This file
│   ├── single-repo-usage.md       Single-repo workflow guide
│   ├── multi-repo-usage.md        Multi-repo workflow guide
│   ├── migration-guide.md         Upgrading from previous versions
│   └── references.md              Claude Code docs that shaped the toolkit
│
├── examples/                      Example outputs and sessions
│   ├── review-report.md           Sample /review-branch output
│   ├── fix-plan.md                Sample /remediation-plan output
│   ├── single-repo-session.md     Full single-repo session transcript
│   └── multi-repo-session.md      Full multi-repo session transcript
│
└── scripts/                       Automation scripts
    ├── install.sh                 Clone + symlink all skills
    ├── relink.sh                  Re-symlink after changes
    ├── validate.sh                Validate repository structure
    └── init-rules.sh              Copy rules to target project
```

## Skill Layers

Skills are organized in two layers. This separation allows both quick one-command workflows and fine-grained manual control.

### Layer 1: Orchestration Skills

These coordinate focused skills into complete workflows. They handle sequencing, user confirmation gates, and summarization.

| Skill | Coordinates | Flow |
|-------|------------|------|
| `implement-ticket` | 7 focused skills | scan → plan → implement → test → review → fix → PR |
| `analyze-codebase` | architecture-scan + integration-check | scan → entry points → complexity → cross-repo map |
| `design-feature` | architecture-scan + integration-check | clarify → analyze → design → contracts → risks |
| `address-feedback` | fix-branch approach | collect → categorize → fix → push |

**When to use**: You have a complete task (ticket, feature request, PR feedback) and want Claude Code to handle the full lifecycle.

### Layer 2: Focused Skills

These do one thing well. Orchestration skills call them, but you can also invoke them directly.

| Skill | Single Responsibility | Input → Output |
|-------|----------------------|----------------|
| `architecture-scan` | Map codebase structure | repo → modules, deps, hot spots |
| `implementation-plan` | Plan the work | task → files, order, risks |
| `review-branch` | Review code | branch → severity-ranked issues |
| `remediation-plan` | Plan fixes | review → prioritized fix plan |
| `fix-branch` | Apply fixes | fix source → code changes |
| `fix-ci` | Fix CI failures | PR → diagnose + fix + push |
| `generate-tests` | Write tests | changed files → test files |
| `create-pr` | Create PR | branch → PR with description |
| `integration-check` | Validate cross-repo | repos → contract mismatches |
| `enhance-prompt` | Transform prompt | rough text → structured prompt |
| `create-skill` | Scaffold skill | description → SKILL.md |

**When to use**: You want control over individual steps, or you're doing something that doesn't fit the orchestration flow (e.g., just reviewing, just fixing CI, just creating a PR).

## Skill Dependency Graph

```
Orchestration Layer
────────────────────────────────────────────────────────────────

  implement-ticket
    ├── architecture-scan
    ├── implementation-plan
    ├── [user writes code]
    ├── generate-tests
    ├── review-branch
    │     └── (if issues) remediation-plan → fix-branch
    ├── integration-check (multi-repo only)
    └── create-pr

  analyze-codebase
    ├── architecture-scan
    └── integration-check (multi-repo only)

  design-feature
    ├── architecture-scan
    └── integration-check (multi-repo only)

  address-feedback
    ├── [reads PR/QA feedback]
    └── fix-branch approach → push

Focused Layer (standalone, no dependencies)
────────────────────────────────────────────────────────────────

  architecture-scan       (reads codebase directly)
  implementation-plan     (benefits from architecture-scan context)
  review-branch           (references .claude/rules/review.md)
  remediation-plan        (takes review-branch output as input)
  fix-branch              (takes any fix source as input)
  fix-ci                  (reads CI logs via gh CLI)
  generate-tests          (detects changed files, existing test patterns)
  create-pr               (reads branch, commits, diff via git + gh)
  integration-check       (scans multiple repos for contract mismatches)
  enhance-prompt          (applies .claude/rules/prompts.md)
  create-skill            (follows .claude/rules/repository-structure.md)
```

## Key Design Decisions

### 1. Rules extraction (DRY standards)

**Problem**: Previous skills each contained 50-100 lines of duplicated engineering standards (SOLID, Clean Code, Security, Performance).

**Solution**: Extract to `.claude/rules/review.md`. Skills reference it with one line: "Apply standards from `.claude/rules/review.md`".

**Benefit**: Update standards once, all skills pick up the change. Skills stay concise (< 80 lines).

### 2. Orchestration over monoliths

**Problem**: Previous `workflow-*` skills were opaque chains with `disable-model-invocation: true`.

**Solution**: Orchestration skills (`implement-ticket`, `analyze-codebase`, `design-feature`, `address-feedback`) that clearly delegate to focused skills with user confirmation gates between phases.

**Benefit**: Users can see what each step does, intervene at any point, or skip steps. Both single-repo and multi-repo modes are supported.

### 3. Design persistence

**Problem**: Feature designs created in one conversation were lost when starting a new conversation for implementation.

**Solution**: `/design-feature` saves output to `.claude/designs/<feature-slug>.md`. `/implement-ticket` checks this directory and reads matching designs automatically.

**Benefit**: Design context survives across conversations. Multiple designs can coexist for parallel work.

### 4. Single-repo as default, multi-repo as extension

**Problem**: Most tasks are single-repo, but some span multiple services.

**Solution**: All skills default to the current repository. Multi-repo support is available through `/integration-check`, `/analyze-codebase` (multi-path), and the multi-repo workflow guide.

**Benefit**: Simple by default, powerful when needed. No configuration required for single-repo use.

### 5. Output to stdout

**Problem**: Previous version wrote to `./claude-context/` files, creating clutter.

**Solution**: Skills output to stdout. Users can save outputs using hooks or copy/paste.

**Benefit**: Simpler, more composable, follows Claude Code conventions. Hooks provide automation for those who want file output.

### 6. Init-rules for portability

**Problem**: Skills reference `.claude/rules/*.md` and `.claude/output-styles/*.md`, but these don't exist in user projects.

**Solution**: `scripts/init-rules.sh` copies rules, output styles, and CLAUDE.md conventions to any target project.

**Benefit**: Skills work correctly in any project after one-time init. The init is idempotent and non-destructive.

## Shared Rules

Rules in `.claude/rules/` define standards that multiple skills reference:

| Rule | What it defines | Referenced by |
|------|----------------|---------------|
| `review.md` | SOLID, Clean Code, Security, Performance, ACID, Testing, Severity levels | `review-branch`, `fix-branch`, `implement-ticket`, `generate-tests` |
| `prompts.md` | Prompt structure, clarity, effectiveness, multi-language | `enhance-prompt` |
| `repository-structure.md` | Skill naming, composition, variables | `create-skill` |
| `single-repo-workflow.md` | 11-step workflow for single-repo tasks | `implement-ticket`, workflow docs |
| `multi-repo-workflow.md` | 10-step workflow for multi-repo tasks | `implement-ticket`, `integration-check`, workflow docs |

## Output Styles

Output styles in `.claude/output-styles/` define reusable formats:

| Style | Structure | Referenced by |
|-------|-----------|---------------|
| `review-report.md` | Severity buckets (Critical → Suggestions), production readiness score (1-10), verdict (APPROVE/REVISE/REJECT), open questions | `review-branch` |
| `fix-plan.md` | Priority groups (P0 Critical → P3 Suggestions), fix strategy per issue, validation checklist, risk assessment | `remediation-plan` |
| `explanatory-dev.md` | Lead with answer, concrete examples, minimal preamble, structured sections | General explanations |

## Agents

Agents in `agents/` define specialized roles:

| Agent | Expertise | Behavioral boundaries |
|-------|-----------|----------------------|
| `system-architect` | Architecture analysis, module mapping, dependency tracking, implementation planning | Does not write code — produces analysis and plans |
| `code-reviewer` | Bug detection, security issues, performance problems, maintainability | Reviews only — does not modify code |
| `code-fixer` | Minimal, correct code changes from review findings | Fixes only what's identified — no gold-plating |
| `security-reviewer` | OWASP Top 10, authentication, authorization, data protection, infrastructure | Security focus only — does not review style or performance |
| `prompt-engineer` | Prompt crafting, optimization, multi-language transformation | Prompt domain only — does not execute prompts |

## Extension Points

### Adding a new skill

1. Create `skills/<verb>-<noun>/SKILL.md` with YAML frontmatter
2. Reference shared rules instead of embedding standards
3. Reference output styles for consistent formatting
4. Run `bash scripts/relink.sh` to symlink
5. Run `bash scripts/validate.sh` to verify

Or use: `/create-skill <description>`

### Adding a new agent

Create `agents/<role>.md` defining: role, responsibilities, tools, behavioral boundaries.

### Adding a new hook

Create `hooks/<event>.example.sh` as a template. Users copy it to their project's `.claude/hooks/` and configure in `.claude/settings.json`.

### Adding a new output style

Create `.claude/output-styles/<artifact>.md` defining the format structure. Skills reference it with: "Use the format from `.claude/output-styles/<artifact>.md`".

### Adding a new rule

Create `.claude/rules/<topic>.md` defining the standard. Skills reference it with: "Apply standards from `.claude/rules/<topic>.md`".
