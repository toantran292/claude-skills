# Claude Skills

Shared skills for Claude Code.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/toantran292/claude-skills/main/install.sh | bash
```

## Skills

Standalone skills that do one thing well.

| Skill | Description |
|-------|-------------|
| `create-skill` | Meta-skill — scaffold a new skill or workflow and update this README |
| `enhance-prompt` | Transform rough prompts (any language) into effective English prompts |
| `execute-prompt` | Execute a well-crafted prompt with maximum quality |
| `fix-branch` | Apply fixes with SOLID, Clean Code, ACID, Security & Optimization standards |
| `review-branch` | Staff/Principal Engineer level code review across multiple repos |

## Workflows

Orchestrated multi-step workflows that combine skills together. Prefixed with `workflow-`.

| Workflow | Description |
|----------|-------------|
| `workflow-prompt-craft` | Enhance any rough idea → confirm → execute → evaluate → iterate until perfect |
| `workflow-review-fix` | Full review → fix → re-review cycle with history tracking and regression detection |

## Usage

### Skills
```
/create-skill a skill that generates unit tests for changed files
/enhance-prompt tạo api cho payment processing
/execute-prompt <your polished prompt>
/fix-branch feat-my-feature
/review-branch feat-my-feature
```

### Workflows
```
/workflow-prompt-craft viết function xử lý thanh toán stripe
/workflow-review-fix feat-my-feature
```

## Update

```bash
cd ~/.claude-skills && git pull
```

Symlinks update automatically.

## Contributing

Want to add a new skill? Fork this repo and submit a PR.

### Quick way (using `create-skill`)

If you already have the skills installed:

```
/create-skill a skill that does X
```

This will scaffold the skill, update the README, and create a PR for you.

### Manual way

1. **Fork** this repo
2. **Create your skill** directory:
   ```
   skills/<skill-name>/SKILL.md
   ```
3. **Follow the naming convention:**
   - Skills (standalone): `<verb>-<noun>` (e.g. `lint-code`, `generate-tests`)
   - Workflows (multi-step): `workflow-<verb>-<noun>` (e.g. `workflow-deploy-check`)
4. **Use the SKILL.md format:**
   ```yaml
   ---
   name: your-skill-name
   description: One-line description
   argument-hint: "example argument"
   ---
   # Your Skill
   Instructions here...
   ```
5. **Update the README** — add your skill to the appropriate table (Skills or Workflows), sorted alphabetically
6. **Submit a PR** from your fork to `main`

### Conventions

- Kebab-case names with verb-noun pattern
- `$ARGUMENTS` for user input
- `disable-model-invocation: true` only for workflows that call other skills
- Imperative voice for instructions
- Clear steps/phases with actionable instructions
