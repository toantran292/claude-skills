# Changelog

## v2.0.0 — 2026-03-11

Complete architecture refactor following Claude Code best practices.

### Added
- `CLAUDE.md` — project conventions loaded by Claude Code
- `.claude/rules/` — shared standards (review, prompts, repository-structure, workflows)
- 4 new skills: `architecture-scan`, `implementation-plan`, `remediation-plan`, `integration-check`
- 5 agents: `system-architect`, `code-reviewer`, `code-fixer`, `security-reviewer`, `prompt-engineer`
- 4 hook examples: after-review, after-fix, notify, protect-critical-files
- 3 output styles: review-report, fix-plan, explanatory-dev
- 5 documentation files: architecture, migration-guide, single-repo, multi-repo, references
- 4 examples: review-report, fix-plan, single-repo-session, multi-repo-session
- `scripts/validate.sh` — structure validation
- Multi-repo workflow support via `integration-check` and documented workflow

### Changed
- `enhance-prompt` — slimmed down, references `rules/prompts.md`
- `review-branch` — slimmed from 215 to ~60 lines, references shared rules and output styles
- `fix-branch` — slimmed from 174 to ~70 lines, references shared rules
- `create-skill` — simplified, removed PR automation
- `install.sh` — moved to `scripts/`, shares logic with relink
- `relink.sh` — moved to `scripts/`, validates SKILL.md exists before linking

### Removed
- `execute-prompt` — standards extracted to rules; prompt execution is native to Claude Code
- `workflow-prompt-craft` — users invoke skills directly in sequence
- `workflow-review-fix` — replaced by documented workflow in rules
- `review-branch/scripts/generate-config.sh` — replaced by `integration-check` skill
- `.claude/settings.local.json` — contained stale/hardcoded entries

## v1.0.0 — Initial release

- 5 standalone skills: create-skill, enhance-prompt, execute-prompt, fix-branch, review-branch
- 2 workflow skills: workflow-prompt-craft, workflow-review-fix
- install.sh and relink.sh
