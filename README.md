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
