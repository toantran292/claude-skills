# Claude Skills

Shared skills for Claude Code.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/toantran292/claude-skills/main/install.sh | bash
```

## Skills

| Skill | Description |
|-------|-------------|
| `enhance-prompt` | Transform rough prompts (Vietnamese/English) into effective English prompts |
| `review-branch` | Staff/Principal Engineer level code review across multiple repos |
| `fix-branch` | Apply fixes with SOLID, Clean Code, ACID, Security & Optimization standards |
| `review-fix-cycle` | Full review → fix → re-review cycle with history tracking |

## Usage

```
/review-branch feat-my-feature
/fix-branch feat-my-feature
/review-fix-cycle feat-my-feature
/enhance-prompt tạo api cho payment processing
```

## Update

```bash
cd ~/.claude-skills && git pull
```

Symlinks update automatically.
