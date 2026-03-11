# Migration Guide

How this repository evolved from the previous version.

## What changed

### Structural changes

| Before | After | Reason |
|--------|-------|--------|
| Monolithic SKILL.md (100-200 lines each) | Concise SKILL.md + shared rules | Reduce duplication |
| `workflow-*` skills calling other skills | Documented workflows in `.claude/rules/` | More flexible, debuggable |
| `./claude-context/` file output | stdout output | Simpler, more composable |
| `generate-config.sh` for multi-repo | `/integration-check` skill | Proper multi-repo support |
| No agents | 5 specialized agents | Clear role separation |
| No hooks | 4 example hooks | Automation support |
| No output styles | 3 output styles | Consistent formatting |
| No rules directory | 5 shared rules | DRY standards |
| `install.sh` + `relink.sh` duplicated logic | Shared symlink logic | DRY scripts |

### Skills changes

| Before | After | Change |
|--------|-------|--------|
| `enhance-prompt` | `enhance-prompt` | Slimmed down, references `rules/prompts.md` |
| `execute-prompt` (204 lines) | Removed | Standards moved to `rules/review.md`, execution is what Claude Code does natively |
| `review-branch` (215 lines) | `review-branch` | Slimmed to ~60 lines, references shared rules and output styles |
| `fix-branch` (174 lines) | `fix-branch` | Slimmed to ~70 lines, references shared rules |
| `create-skill` (139 lines) | `create-skill` | Slimmed, removed PR automation |
| `workflow-prompt-craft` | Removed | Users run `/enhance-prompt` then work directly |
| `workflow-review-fix` | Removed | Replaced by documented workflow in `rules/single-repo-workflow.md` |
| — | `architecture-scan` | New — understand codebase before changes |
| — | `implementation-plan` | New — concrete planning before implementation |
| — | `remediation-plan` | New — structured fix planning from reviews |
| — | `integration-check` | New — multi-repo consistency validation |

### Removed files

| File | Reason |
|------|--------|
| `skills/execute-prompt/SKILL.md` | Standards extracted to rules; prompt execution is native |
| `skills/workflow-prompt-craft/SKILL.md` | Unnecessary orchestration |
| `skills/workflow-review-fix/SKILL.md` | Replaced by documented workflow |
| `skills/review-branch/scripts/generate-config.sh` | Replaced by `/integration-check` |
| `.claude/settings.local.json` | Contained stale/hardcoded entries |

### New files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project conventions for Claude Code |
| `.claude/rules/*.md` | Shared standards |
| `agents/*.md` | Subagent definitions |
| `hooks/*.example.sh` | Automation examples |
| `output-styles/*.md` | Output format templates |
| `docs/*.md` | Architecture and usage docs |
| `examples/*.md` | Example outputs |
| `scripts/validate.sh` | Structure validation |

## Migration steps

If you were using the previous version:

1. Run `cd ~/.claude-skills && git pull` to get the new version
2. Run `bash scripts/relink.sh` to update symlinks
3. The following skills work the same: `/enhance-prompt`, `/review-branch`, `/fix-branch`, `/create-skill`
4. Replace `/workflow-review-fix <branch>` with the manual workflow: `/review-branch` → `/remediation-plan` → `/fix-branch`
5. Replace `/execute-prompt` with direct prompting (Claude Code does this natively)
6. Use the new skills: `/architecture-scan`, `/implementation-plan`, `/remediation-plan`, `/integration-check`
