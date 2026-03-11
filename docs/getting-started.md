# Getting Started

A step-by-step guide to installing and using the Claude Skills Toolkit for the first time.

## Prerequisites

- **Claude Code** — installed and configured ([claude.ai/code](https://claude.ai/code))
- **Git** — your project must be a git repository
- **gh CLI** (optional) — needed for `/fix-ci`, `/create-pr`, `/address-feedback` — `brew install gh`

## Step 1: Install the toolkit

```bash
curl -fsSL https://raw.githubusercontent.com/toantran292/claude-skills/main/scripts/install.sh | bash
```

What this does:
1. Clones the toolkit to `~/.claude-skills`
2. Creates `~/.claude/skills/` if it doesn't exist
3. Symlinks each skill directory to `~/.claude/skills/<skill-name>`

After installation, Claude Code can discover all 15 skills via slash commands.

## Step 2: Init rules in your project

Skills reference shared rules (code review standards, prompt engineering rules, workflows). These need to exist in your project's `.claude/` directory:

```bash
bash ~/.claude-skills/scripts/init-rules.sh /path/to/your/project
```

What this copies:
- `.claude/rules/review.md` — SOLID, Clean Code, Security, Performance, ACID, Testing standards
- `.claude/rules/prompts.md` — prompt engineering rules
- `.claude/rules/repository-structure.md` — naming and composition conventions
- `.claude/rules/single-repo-workflow.md` — 11-step single-repo workflow
- `.claude/rules/multi-repo-workflow.md` — 10-step multi-repo workflow
- `output-styles/review-report.md` — review output format
- `output-styles/fix-plan.md` — fix plan output format
- `output-styles/explanatory-dev.md` — explanation output format
- `CLAUDE.md` — commit conventions (Conventional Commits, no Co-Authored-By)

This is idempotent — running it again skips files that already exist.

## Step 3: Verify installation

Open Claude Code in your project and type:

```
/review-branch
```

If the skill loads and starts analyzing your branch, everything is working.

## Your first workflow

### Option A: One-command (recommended for most tasks)

```
/implement-ticket add a health check endpoint at GET /health
```

Claude Code will:
1. Ask clarifying questions about requirements
2. Scan your codebase architecture
3. Create an implementation plan
4. Write the code
5. Generate tests
6. Review the changes
7. Fix any issues found
8. Create a pull request

You just confirm at each gate.

### Option B: Step-by-step (for learning or fine control)

```
/architecture-scan
```

Read the output to understand your codebase modules and dependencies.

```
/implementation-plan add a health check endpoint at GET /health
```

Review the plan — affected files, implementation order, risks.

Now write the code yourself (or let Claude Code help).

```
/generate-tests
```

Tests are written following your project's existing test patterns.

```
/review-branch
```

Get a severity-ranked review. If issues are found:

```
/remediation-plan from last review
/fix-branch
```

When ready:

```
/create-pr
```

A structured PR is created with description, test plan, and risk notes.

## Common scenarios

### "I'm new to this codebase"

```
/analyze-codebase
```

Produces a structured overview: modules, dependencies, entry points, complexity areas.

### "I need to design before coding"

```
/design-feature add real-time notification system with email and push channels
```

Produces a system design saved to `.claude/designs/`. When you later run `/implement-ticket`, it reads the design automatically.

### "PR reviewer left comments"

```
/address-feedback 42
```

Reads PR #42 review comments, categorizes them (must-fix, should-fix, optional), applies fixes, and pushes.

### "CI is failing"

```
/fix-ci 42
```

Reads failing CI checks, fetches logs, diagnoses failures, fixes code issues, and pushes.

### "I need a quick prompt"

```
/enhance-prompt tạo api cho payment processing với stripe webhook
```

Transforms rough input (any language) into a clear, structured English prompt.

### "I want to add a new skill to the toolkit"

```
/create-skill a skill that generates database migrations from schema changes
```

Scaffolds a new skill following toolkit conventions.

## Updating

```bash
cd ~/.claude-skills && git pull && bash scripts/relink.sh
```

This pulls the latest skills and re-symlinks them. Your project's `.claude/rules/` files are not affected — run `init-rules.sh` again if you want the latest rules.

## Troubleshooting

### Skills not showing up

1. Check symlinks exist: `ls -la ~/.claude/skills/`
2. Re-run: `bash ~/.claude-skills/scripts/relink.sh`
3. Restart Claude Code

### "Rules not found" errors

Skills reference `.claude/rules/*.md` files. Run init-rules in your project:

```bash
bash ~/.claude-skills/scripts/init-rules.sh /path/to/your/project
```

### `gh` CLI errors

Skills like `/fix-ci`, `/create-pr`, and `/address-feedback` require the GitHub CLI:

```bash
brew install gh
gh auth login
```

### Skill does unexpected things

Each skill's full logic is in `skills/<name>/SKILL.md`. Read it to understand exactly what it does. Skills are just markdown — you can customize them.

## Next steps

- Read the [single-repo workflow guide](single-repo-usage.md) for the full 11-step workflow
- Read the [multi-repo workflow guide](multi-repo-usage.md) for cross-service development
- Read the [architecture doc](architecture.md) to understand how components fit together
- Browse [examples/](../examples/) for real session transcripts
