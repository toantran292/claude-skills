# Claude Skills Toolkit

Engineering toolkit for Claude Code — skills, agents, hooks, output styles, and reusable rules for real-world development.

Supports both single-repo and multi-repo workflows.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/toantran292/claude-skills/main/scripts/install.sh | bash
```

## Architecture

```
skills/           Focused, single-responsibility skills
agents/           Specialized subagent definitions
hooks/            Example hook scripts for automation
output-styles/    Standardized output formats
.claude/rules/    Shared standards referenced by skills
docs/             Architecture and usage documentation
examples/         Example outputs and session transcripts
scripts/          Install, relink, and validation
```

Shared engineering standards live in `.claude/rules/` and are referenced by skills — no duplication. See [docs/architecture.md](docs/architecture.md) for details.

## Skills

### Orchestration skills

High-level skills that coordinate lower-level skills into complete workflows.

| Skill | Description |
|-------|-------------|
| `/analyze-codebase` | Understand a repo quickly — architecture, modules, integrations, complexity |
| `/design-feature` | Transform a feature request into a system design proposal |
| `/implement-ticket` | End-to-end: scan → plan → implement → test → review → fix → PR |
| `/address-feedback` | Read PR/QA feedback, categorize issues, apply fixes, and push |

### Focused skills

Single-responsibility skills that do one thing well.

| Skill | Description |
|-------|-------------|
| `/architecture-scan` | Analyze codebase structure, modules, dependencies, and hot spots |
| `/create-skill` | Scaffold a new skill aligned with toolkit conventions |
| `/enhance-prompt` | Transform a rough prompt (any language) into a clear English prompt |
| `/create-pr` | Create a pull request with structured description and test plan |
| `/fix-branch` | Apply targeted fixes from any source (review, PR feedback, QA, direct) |
| `/generate-tests` | Generate tests for changed or untested code on the current branch |
| `/implementation-plan` | Generate a concrete plan with affected files, order, risks, validation |
| `/integration-check` | Validate cross-repo consistency (APIs, events, schemas, naming) |
| `/remediation-plan` | Convert review findings into a prioritized fix plan |
| `/review-branch` | Review current branch with severity-ranked issues |

## Agents

| Agent | Role |
|-------|------|
| `system-architect` | Analyze architecture, design implementation plans |
| `code-reviewer` | Review code with Staff/Principal Engineer rigor |
| `code-fixer` | Apply minimal, correct fixes from review findings |
| `security-reviewer` | Identify security vulnerabilities (OWASP, auth, data) |
| `prompt-engineer` | Craft and optimize prompts |

## Hooks

Example automation scripts in `hooks/`. See [hooks/README.md](hooks/README.md).

| Hook | Purpose |
|------|---------|
| `after-review.example.sh` | Save review output after `/review-branch` |
| `after-fix.example.sh` | Run tests after `/fix-branch` |
| `notify.example.sh` | Send Slack notification after events |
| `protect-critical-files.example.sh` | Block edits to migrations, CI, configs |

## Output Styles

| Style | Purpose |
|-------|---------|
| `review-report.md` | Structured review with severity buckets |
| `fix-plan.md` | Prioritized fix plan with validation steps |
| `explanatory-dev.md` | Concise technical explanations for engineers |

## Single-Repo Workflow

For implementing a feature in one repository:

```
/architecture-scan              # Understand the codebase
/implementation-plan <task>     # Plan the work
[implement]                     # Write the code
/generate-tests                 # Write tests for changed code
/review-branch                  # Review your changes
/remediation-plan               # Plan fixes (if needed)
/fix-branch                     # Apply fixes
/create-pr                      # Push and create PR
/address-feedback <PR#>         # Handle reviewer feedback
```

See [docs/single-repo-usage.md](docs/single-repo-usage.md) for the full guide.

## Multi-Repo Workflow

For implementing a feature across multiple services:

```
/architecture-scan              # Scan each repo
/implementation-plan <task>     # Plan per repo
[implement per repo]            # Providers before consumers
/generate-tests                 # Write tests per repo
/review-branch                  # Review each repo
/integration-check              # Validate cross-repo consistency
/remediation-plan               # Plan fixes (if needed)
/fix-branch                     # Fix per repo
/create-pr                      # Create PRs per repo, link them
```

See [docs/multi-repo-usage.md](docs/multi-repo-usage.md) for the full guide.

## Update

```bash
cd ~/.claude-skills && git pull && bash scripts/relink.sh
```

## Development

### Validate structure

```bash
bash scripts/validate.sh
```

### Add a new skill

```
/create-skill a skill that generates unit tests for changed files
```

Or manually: create `skills/<verb>-<noun>/SKILL.md` following [.claude/rules/repository-structure.md](.claude/rules/repository-structure.md).

### Conventions

- Kebab-case `<verb>-<noun>` names
- `$ARGUMENTS` for user input
- Reference `.claude/rules/` for shared standards — don't duplicate
- Reference `output-styles/` for output formats
- Keep SKILL.md concise (< 80 lines)

## Documentation

| Doc | Content |
|-----|---------|
| [docs/architecture.md](docs/architecture.md) | Design philosophy and component relationships |
| [docs/migration-guide.md](docs/migration-guide.md) | Changes from the previous version |
| [docs/single-repo-usage.md](docs/single-repo-usage.md) | Step-by-step single-repo workflow |
| [docs/multi-repo-usage.md](docs/multi-repo-usage.md) | Step-by-step multi-repo workflow |
| [docs/references.md](docs/references.md) | Claude Code documentation references |

## Examples

| Example | Shows |
|---------|-------|
| [examples/review-report.md](examples/review-report.md) | Sample `/review-branch` output |
| [examples/fix-plan.md](examples/fix-plan.md) | Sample `/remediation-plan` output |
| [examples/single-repo-session.md](examples/single-repo-session.md) | Full single-repo session transcript |
| [examples/multi-repo-session.md](examples/multi-repo-session.md) | Full multi-repo session transcript |

## References

Built following Claude Code documentation:
- [Skills](https://code.claude.com/docs/en/skills) — skill format and conventions
- [Memory / CLAUDE.md](https://code.claude.com/docs/en/memory) — project rules and memory
- [Sub-agents](https://code.claude.com/docs/en/sub-agents) — agent definitions
- [Hooks](https://code.claude.com/docs/en/hooks-guide) — hook lifecycle
- [Output styles](https://code.claude.com/docs/en/output-styles) — standardized formats
- [Best practices](https://code.claude.com/docs/en/best-practices) — architecture principles

See [docs/references.md](docs/references.md) for how each influenced the design.
