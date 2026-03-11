# Changelog

## v2.3.0 — 2026-03-11

Complete documentation overhaul — detailed guides, examples, and getting-started walkthrough.

### Added
- `docs/getting-started.md` — new quick start guide with first-use walkthrough and troubleshooting
- Collapsible skill details in README with step-by-step explanations
- Detailed example outputs in all workflow guides
- ASCII component relationship diagram in architecture docs
- Tips and "when to skip" guidance in single-repo and multi-repo guides
- Complete skill reference table in migration guide

### Changed
- README rewritten with Quick Start, How It Works, detailed skill tables, workflow examples
- `docs/architecture.md` rewritten with component diagram, annotated directory layout, design decisions
- `docs/single-repo-usage.md` rewritten with example outputs for every step, skip guidance, tips
- `docs/multi-repo-usage.md` rewritten with clear per-repo session pattern, example outputs
- `docs/migration-guide.md` rewritten with version history format, clear upgrade instructions
- `examples/single-repo-session.md` updated with realistic outputs, CI fix step, more detail
- `examples/multi-repo-session.md` fixed to use per-repo sessions instead of `cd &&` pattern

## v2.2.0 — 2026-03-11

Complete developer workflow coverage — from ticket to QA acceptance.

### Added
- 3 new skills: `generate-tests`, `create-pr`, `address-feedback`
- Full 11-step developer workflow in `rules/single-repo-workflow.md`
- Updated docs: architecture, single-repo-usage, migration-guide with new skills

### Changed
- `fix-branch` — now accepts any fix source (review, PR feedback, QA bugs, direct description)
- `implement-ticket` — added test generation (step 5), PR creation (step 9), 10 steps total
- Updated README with new skills in both focused and workflow sections
- Updated `validate.sh` to check for new skills

## v2.1.0 — 2026-03-11

Add orchestration skills that coordinate focused skills into complete workflows.

### Added
- 3 orchestration skills: `analyze-codebase`, `design-feature`, `implement-ticket`
- Orchestration skills section in README
- Updated docs: architecture (skill layers), single-repo, multi-repo, migration guide
- Updated examples: single-repo and multi-repo now show both orchestration and manual approaches

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
