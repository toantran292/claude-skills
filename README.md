# Claude Skills Toolkit

Engineering toolkit for [Claude Code](https://claude.ai/code) — a complete set of skills, agents, hooks, output styles, and reusable rules that turn Claude Code into a full software development workflow engine.

Supports both **single-repo** and **multi-repo** workflows. From understanding a codebase to shipping a PR — every step is covered.

## Quick Start

### 1. Install

```bash
curl -fsSL https://raw.githubusercontent.com/toantran292/claude-skills/main/scripts/install.sh | bash
```

This clones the toolkit to `~/.claude-skills` and symlinks all skills to `~/.claude/skills/` so Claude Code can discover them.

### 2. Init rules in your project

```bash
bash ~/.claude-skills/scripts/init-rules.sh /path/to/your/project
```

This copies shared rules (`.claude/rules/`), output styles (`.claude/output-styles/`), and commit conventions into your project's `.claude/` directory — so skills have full context when working in that project. Does not touch your `CLAUDE.md`.

### 3. Start using

```
/implement-ticket add user notification preferences with email opt-in
```

That's it. Claude Code will scan the codebase, plan, implement, write tests, review, fix issues, and create a PR — all in one command.

## How It Works

```
You type a slash command (e.g. /review-branch)
    ↓
Claude Code loads the skill's SKILL.md
    ↓
Skill references shared rules (.claude/rules/review.md)
    ↓
Skill references output styles (.claude/output-styles/review-report.md)
    ↓
Skill may delegate to agents (agents/code-reviewer.md)
    ↓
Hooks fire after execution (optional automation)
```

Skills are composable. Orchestration skills coordinate focused skills. Focused skills do one thing well. You can use either layer depending on how much control you want.

## Project Structure

```
claude-skills/
├── skills/              16 skills (4 orchestration + 12 focused)
│   └── <skill-name>/
│       └── SKILL.md     One file per skill, YAML frontmatter + markdown
├── agents/              5 specialized subagent definitions
│   └── <role>.md
├── hooks/               4 example automation scripts
│   └── <event>.example.sh
├── .claude/output-styles/       3 standardized output format templates
│   └── <artifact>.md
├── .claude/rules/       5 shared standards referenced by skills
│   └── <topic>.md
├── docs/                Architecture, usage guides, migration, references
├── examples/            Example outputs and full session transcripts
├── scripts/             Install, relink, validate, init-rules
└── CLAUDE.md            Project conventions (loaded by Claude Code)
```

## Skills

### Orchestration Skills

High-level skills that run complete workflows by coordinating focused skills. These handle the full lifecycle — from understanding to shipping.

| Skill | What it does | When to use |
|-------|-------------|-------------|
| `/implement-ticket` | End-to-end: scan → plan → implement → test → review → fix → PR | You have a ticket/task to implement |
| `/analyze-codebase` | Full codebase analysis: architecture, modules, entry points, complexity | Onboarding to a new codebase or before a large task |
| `/design-feature` | Feature request → system design with architecture flow, risks, contracts | Before implementing a complex feature |
| `/address-feedback` | Read PR/QA feedback → categorize → fix → push | After PR review or QA testing |

### Focused Skills

Single-responsibility skills that do one thing well. Use these for fine-grained control, or let orchestration skills call them automatically.

| Skill | What it does | Input |
|-------|-------------|-------|
| `/architecture-scan` | Map codebase structure, modules, dependencies, hot spots | Path or description (optional) |
| `/implementation-plan` | Concrete plan with affected files, order, risks, validation | Task description |
| `/review-branch` | Staff-level code review with severity-ranked issues | Branch name (optional, defaults to current) |
| `/review-pr` | Staff-level code review on a GitHub PR via `gh` CLI | PR number or "current" |
| `/remediation-plan` | Convert review findings into prioritized fix plan | Review findings or "from last review" |
| `/fix-branch` | Apply targeted fixes from any source | Description, PR number, or "from last review" |
| `/fix-ci` | Diagnose failing CI checks, fix code issues, push | PR number or "current" |
| `/generate-tests` | Write tests for changed/untested code (happy + edge + error) | File/module (optional, defaults to changed files) |
| `/create-pr` | Create PR with structured description and test plan | Title (optional, auto-generated from commits) |
| `/integration-check` | Validate cross-repo consistency (APIs, events, schemas) | List of repos/services |
| `/enhance-prompt` | Transform rough prompt (any language) → clear English prompt | Your rough prompt |
| `/create-skill` | Scaffold a new skill following toolkit conventions | Skill description |

### Skill Details

<details>
<summary><code>/implement-ticket</code> — End-to-end implementation</summary>

The most powerful skill. Runs the full development cycle:

1. **Clarify** — confirms requirements and acceptance criteria
2. **Scan** — runs `/architecture-scan` to understand affected modules
3. **Plan** — runs `/implementation-plan` to produce a concrete plan
4. **Implement** — writes the code following the plan
5. **Test** — runs `/generate-tests` to write tests for changed code
6. **Review** — runs `/review-branch` for severity-ranked review
7. **Fix** — runs `/remediation-plan` + `/fix-branch` if issues found
8. **Integration** — runs `/integration-check` if multi-repo (optional)
9. **PR** — runs `/create-pr` to push and create the pull request
10. **Summary** — presents changes, tests, review result, and PR URL

**Design context**: If you ran `/design-feature` earlier, the design is saved to `.claude/designs/`. `/implement-ticket` reads it automatically — even in a new conversation.

```
/implement-ticket add email notification preferences with per-channel opt-in
```
</details>

<details>
<summary><code>/design-feature</code> — System design before code</summary>

Produces a system design proposal before any code is written:

1. **Clarify** — confirms user-facing behavior, triggers, inputs/outputs, constraints
2. **Analyze** — scans current architecture to understand modules and patterns
3. **Design** — data flow, module ownership, new vs modified, integration points
4. **Multi-repo** — maps repo ownership, contracts, deployment order (if applicable)
5. **Risks** — technical, integration, scope risks with mitigations

The design is saved to `.claude/designs/<feature-slug>.md`. Multiple designs can coexist for parallel work.

```
/design-feature add real-time notification system with email, SMS, and push channels
```
</details>

<details>
<summary><code>/review-branch</code> — Staff-level code review</summary>

Reviews code changes with the rigor of a Staff/Principal Engineer:

- Applies standards from `.claude/rules/review.md` (SOLID, Clean Code, Security, Performance, ACID)
- Outputs using `.claude/output-styles/review-report.md` format
- Produces severity-ranked issues: Critical, Major, Minor, Suggestions
- Includes production readiness score (1-10) and approval recommendation

```
/review-branch
```
</details>

<details>
<summary><code>/review-pr</code> — Review code on a GitHub PR</summary>

Reviews code changes on a pull request remotely via `gh` CLI — no need to check out the branch:

- Fetches PR diff, metadata, and existing review comments via `gh pr diff` and `gh api`
- Applies the same Staff/Principal Engineer standards as `/review-branch`
- Can optionally post the review directly to GitHub as PR review comments

```
/review-pr 42
/review-pr current
```
</details>

<details>
<summary><code>/fix-ci</code> — Fix failing CI checks</summary>

Reads CI check results from a PR via `gh` CLI, diagnoses failures, and fixes them:

1. **Identify** the PR (from argument, current branch, or asks)
2. **Get checks** — reads all check statuses via `gh pr checks`
3. **Read logs** — fetches failed check logs via `gh run view --log-failed`
4. **Diagnose** — categorizes: test failure, lint, build error, type error, flaky/infra
5. **Fix** — applies minimal code fixes for each fixable failure
6. **Push** — commits and pushes with Conventional Commits format
7. **Verify** — monitors CI re-run

```
/fix-ci 42
/fix-ci current
```
</details>

<details>
<summary><code>/address-feedback</code> — Handle PR/QA feedback</summary>

Reads feedback from PR reviews or QA, categorizes it, and applies fixes:

- Collects feedback via `gh` CLI (PR comments) or direct pasting
- Categorizes: must-fix, should-fix, optional, questions
- Applies fixes one by one with verification
- Pushes with Conventional Commits format

```
/address-feedback 42           # Read PR #42 review comments
/address-feedback from QA      # Apply QA bug fixes
```
</details>

## Agents

Specialized subagents with focused expertise. Skills delegate to these for domain-specific work.

| Agent | Expertise | Used by |
|-------|-----------|---------|
| `system-architect` | Architecture analysis, implementation planning | `/architecture-scan`, `/implementation-plan` |
| `code-reviewer` | Staff-level code review, bug detection | `/review-branch`, `/review-pr` |
| `code-fixer` | Minimal, correct code fixes | `/fix-branch`, `/fix-ci` |
| `security-reviewer` | OWASP Top 10, auth, data protection | `/review-branch` (security focus) |
| `prompt-engineer` | Prompt crafting and optimization | `/enhance-prompt` |

## Hooks

Example automation scripts in [hooks/](hooks/). Copy to your project and configure in `.claude/settings.json`.

| Hook | What it automates |
|------|-------------------|
| `after-review.example.sh` | Save review output to file after `/review-branch` |
| `after-fix.example.sh` | Run tests automatically after `/fix-branch` |
| `notify.example.sh` | Send Slack/email notification after events |
| `protect-critical-files.example.sh` | Block edits to migrations, CI configs, .env |

See [hooks/README.md](hooks/README.md) for setup instructions.

## Output Styles

Standardized formats that ensure consistent, professional output across skills.

| Style | Format | Used by |
|-------|--------|---------|
| `review-report.md` | Severity buckets + production readiness score + verdict | `/review-branch` |
| `fix-plan.md` | Priority groups + fix strategy + validation checklist | `/remediation-plan` |
| `explanatory-dev.md` | Lead-with-answer + concrete examples + minimal preamble | General explanations |

## Workflows

### Single-Repo: One-command approach

```
/implement-ticket add user notification preferences with email opt-in
```

Runs the full cycle automatically. See [docs/single-repo-usage.md](docs/single-repo-usage.md) for the detailed guide.

### Single-Repo: Manual step-by-step

```
/architecture-scan                          # 1. Understand the codebase
/implementation-plan add notifications      # 2. Plan the work
[write the code]                            # 3. Implement
/generate-tests                             # 4. Write tests
/review-branch                              # 5. Review changes
/remediation-plan from last review          # 6. Plan fixes (if needed)
/fix-branch                                 # 7. Apply fixes
/create-pr                                  # 8. Push + create PR
/address-feedback 42                        # 9. Handle reviewer feedback
/fix-ci 42                                  # 10. Fix CI failures (if any)
```

### Multi-Repo: Design → Implement per repo

```
# 1. Design the cross-service feature (from any repo)
/design-feature add notification preferences across api, worker, notification services

# 2. Implement in each repo (open each repo separately)
#    In api-service:
/implement-ticket add notification preferences CRUD and publish PreferenceUpdated events

#    In worker-service:
/implement-ticket consume PreferenceUpdated events from api-service

#    In notification-service:
/implement-ticket respect user preferences when sending notifications

# 3. Validate integration (from any repo, pass all paths)
/integration-check api-service worker-service notification-service
```

See [docs/multi-repo-usage.md](docs/multi-repo-usage.md) for the detailed guide.

### Quick workflow (small changes)

For bug fixes, config changes, or typos:

```
[make changes]
/review-branch              # Quick review
/create-pr                  # Ship it
```

## Setup

### Install

```bash
# Fresh install
curl -fsSL https://raw.githubusercontent.com/toantran292/claude-skills/main/scripts/install.sh | bash

# Update existing installation
cd ~/.claude-skills && git pull && bash scripts/relink.sh
```

### Init rules in your project

Skills reference shared rules in `.claude/rules/` and output styles. Run this once per project to copy them:

```bash
bash ~/.claude-skills/scripts/init-rules.sh /path/to/your/project
```

This copies:
- `.claude/rules/*.md` — code review standards, prompt rules, workflows
- `.claude/output-styles/*.md` — review report, fix plan, explanatory formats

Idempotent — safe to run multiple times. Skips files that already exist.

### Prerequisites

- [Claude Code](https://claude.ai/code) installed and configured
- `gh` CLI (for `/fix-ci`, `/create-pr`, `/address-feedback`) — `brew install gh`
- Git repository initialized in your project

## Development

### Validate structure

```bash
bash scripts/validate.sh
```

Checks: all required skills exist, SKILL.md format is correct, directories are present, no broken references.

### Add a new skill

```
/create-skill a skill that generates database migration files from schema changes
```

Or manually: create `skills/<verb>-<noun>/SKILL.md` following [.claude/rules/repository-structure.md](.claude/rules/repository-structure.md).

### Conventions

- **Naming**: kebab-case `<verb>-<noun>` (e.g. `review-branch`, `fix-ci`)
- **Input**: `$ARGUMENTS` for user input in SKILL.md
- **Rules**: reference `.claude/rules/` — never duplicate standards
- **Output**: reference `.claude/output-styles/` for consistent formatting
- **Size**: keep SKILL.md concise (< 80 lines)
- **Commits**: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) — never include Co-Authored-By

## Documentation

| Doc | What it covers |
|-----|----------------|
| [docs/getting-started.md](docs/getting-started.md) | Quick start guide with first-use walkthrough |
| [docs/architecture.md](docs/architecture.md) | Design philosophy, component relationships, skill layers |
| [docs/single-repo-usage.md](docs/single-repo-usage.md) | Complete single-repo workflow guide |
| [docs/multi-repo-usage.md](docs/multi-repo-usage.md) | Complete multi-repo workflow guide |
| [docs/migration-guide.md](docs/migration-guide.md) | Upgrading from previous versions |
| [docs/references.md](docs/references.md) | Claude Code documentation that influenced the design |

## Examples

| Example | What it shows |
|---------|---------------|
| [examples/review-report.md](examples/review-report.md) | Sample `/review-branch` output with severity buckets |
| [examples/fix-plan.md](examples/fix-plan.md) | Sample `/remediation-plan` output with prioritized fixes |
| [examples/single-repo-session.md](examples/single-repo-session.md) | Full single-repo session (orchestration + manual) |
| [examples/multi-repo-session.md](examples/multi-repo-session.md) | Full multi-repo session across 3 services |

## References

Built following [Claude Code documentation](https://code.claude.com/docs/en):

- [Skills](https://code.claude.com/docs/en/skills) — SKILL.md format, `$ARGUMENTS`, YAML frontmatter
- [Memory / CLAUDE.md](https://code.claude.com/docs/en/memory) — project rules and `.claude/rules/`
- [Sub-agents](https://code.claude.com/docs/en/sub-agents) — agent role definitions
- [Hooks](https://code.claude.com/docs/en/hooks-guide) — hook lifecycle and configuration
- [Output styles](https://code.claude.com/docs/en/output-styles) — standardized formats
- [Best practices](https://code.claude.com/docs/en/best-practices) — architecture principles

See [docs/references.md](docs/references.md) for how each influenced the toolkit design.
