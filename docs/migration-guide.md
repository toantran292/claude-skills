# Migration Guide

How to upgrade from previous versions of the Claude Skills Toolkit.

## Upgrading to Latest

```bash
cd ~/.claude-skills && git pull && bash scripts/relink.sh
```

Then optionally update rules in each project:

```bash
bash ~/.claude-skills/scripts/init-rules.sh /path/to/your/project
```

## Version History

### v2.3.0 — Documentation overhaul

No skill changes. Complete rewrite of all documentation for clarity and detail.

**What's new**:
- `docs/getting-started.md` — new quick start guide with first-use walkthrough
- All docs rewritten with detailed examples, step-by-step instructions, and tips
- README rewritten with skill details, collapsible sections, and workflow guides
- Example sessions updated with realistic outputs and corrected patterns

**No action needed** — just pull the latest.

### v2.2.0 — Complete developer workflow

Three new focused skills that complete the development lifecycle.

**New skills**:
| Skill | What it does |
|-------|-------------|
| `/generate-tests` | Write tests for changed/untested code |
| `/create-pr` | Create PR with structured description and test plan |
| `/address-feedback` | Read PR/QA feedback, categorize, fix, push |

**Changed skills**:
| Skill | What changed |
|-------|-------------|
| `/fix-branch` | Now accepts any fix source: review, PR feedback, QA bugs, direct description |
| `/implement-ticket` | Added test generation (step 5) and PR creation (step 9), now 10 steps |

**New rules**:
- `single-repo-workflow.md` updated to 11 steps (added Test, PR, Feedback, QA)

**Migration**: Pull and relink. New skills are available immediately.

### v2.1.0 — Orchestration skills

Four orchestration skills that coordinate focused skills into complete workflows.

**New skills**:
| Skill | What it does |
|-------|-------------|
| `/implement-ticket` | End-to-end: scan → plan → implement → test → review → fix → PR |
| `/analyze-codebase` | Full codebase analysis with modules, entry points, complexity |
| `/design-feature` | Feature request → system design with architecture flow and risks |
| `/address-feedback` | Read PR/QA feedback → categorize → fix → push |

**Design persistence**: `/design-feature` saves output to `.claude/designs/`. `/implement-ticket` reads it automatically in future conversations.

**Migration**: Pull and relink. Orchestration skills are additive — existing skills unchanged.

### v2.0.0 — Architecture refactor

Complete restructure following Claude Code best practices.

**What changed**:

| Before (v1) | After (v2) | Reason |
|-------------|-----------|--------|
| Monolithic SKILL.md (100-200 lines) | Concise SKILL.md + shared rules | DRY — standards in one place |
| `workflow-*` skills | Orchestration skills + documented workflows | More flexible, user confirmation gates |
| `./claude-context/` file output | stdout output | Simpler, more composable |
| `generate-config.sh` for multi-repo | `/integration-check` skill | Proper multi-repo validation |
| No agents, hooks, styles, rules | 5 agents, 4 hooks, 3 styles, 5 rules | Complete toolkit |

**Removed**:
| What | Replacement |
|------|-------------|
| `execute-prompt` skill | Standards in `.claude/rules/review.md`. Prompt execution is native to Claude Code. |
| `workflow-prompt-craft` skill | Run `/enhance-prompt` directly |
| `workflow-review-fix` skill | Manual workflow: `/review-branch` → `/remediation-plan` → `/fix-branch` |
| `generate-config.sh` script | `/integration-check` skill |
| `.claude/settings.local.json` | Removed (contained stale entries) |

**Added**:
| Category | Files |
|----------|-------|
| Skills | `architecture-scan`, `implementation-plan`, `remediation-plan`, `integration-check` |
| Agents | `system-architect`, `code-reviewer`, `code-fixer`, `security-reviewer`, `prompt-engineer` |
| Hooks | `after-review`, `after-fix`, `notify`, `protect-critical-files` (all `.example.sh`) |
| Output styles | `review-report`, `fix-plan`, `explanatory-dev` |
| Rules | `review`, `prompts`, `repository-structure`, `single-repo-workflow`, `multi-repo-workflow` |
| Docs | `architecture`, `single-repo-usage`, `multi-repo-usage`, `migration-guide`, `references` |
| Scripts | `validate.sh`, `init-rules.sh` |

**Migration from v1**:

1. Pull and relink:
   ```bash
   cd ~/.claude-skills && git pull && bash scripts/relink.sh
   ```

2. These skills work the same (just slimmer):
   - `/enhance-prompt` — references `rules/prompts.md` instead of embedding rules
   - `/review-branch` — references `rules/review.md` and `.claude/output-styles/review-report.md`
   - `/fix-branch` — references `rules/review.md`, accepts any fix source
   - `/create-skill` — simplified, follows `rules/repository-structure.md`

3. Replace removed skills:
   - `/workflow-review-fix <branch>` → use the manual workflow: `/review-branch` → `/remediation-plan` → `/fix-branch`
   - `/execute-prompt` → just prompt Claude Code directly. Standards are in `.claude/rules/review.md`.

4. Init rules in your projects:
   ```bash
   bash ~/.claude-skills/scripts/init-rules.sh /path/to/your/project
   ```

5. Use new skills:
   - `/architecture-scan` — understand codebase before changes
   - `/implementation-plan <task>` — concrete plan before implementation
   - `/remediation-plan from last review` — structured fix planning
   - `/integration-check <repos>` — multi-repo contract validation

6. Use orchestration skills for complete workflows:
   - `/implement-ticket <task>` — end-to-end implementation
   - `/analyze-codebase` — full codebase analysis
   - `/design-feature <description>` — system design before code
   - `/address-feedback <PR#>` — handle reviewer/QA feedback

## All Skills (Current)

### Orchestration (4)

| Skill | Description | Coordinates |
|-------|-------------|------------|
| `/implement-ticket` | End-to-end implementation | scan → plan → implement → test → review → fix → PR |
| `/analyze-codebase` | Full codebase analysis | architecture-scan + integration-check |
| `/design-feature` | Feature → system design | architecture-scan + integration-check |
| `/address-feedback` | PR/QA feedback → fixes | collect → categorize → fix → push |

### Focused (11)

| Skill | Description |
|-------|-------------|
| `/architecture-scan` | Map codebase structure, modules, dependencies |
| `/implementation-plan` | Concrete plan with files, order, risks |
| `/review-branch` | Severity-ranked code review |
| `/remediation-plan` | Review findings → prioritized fix plan |
| `/fix-branch` | Apply targeted fixes from any source |
| `/fix-ci` | Diagnose + fix failing CI checks |
| `/generate-tests` | Write tests for changed code |
| `/create-pr` | Create PR with structured description |
| `/integration-check` | Cross-repo contract validation |
| `/enhance-prompt` | Transform rough prompt → structured English |
| `/create-skill` | Scaffold new skill following conventions |
