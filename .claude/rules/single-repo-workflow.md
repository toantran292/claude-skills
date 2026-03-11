# Single-Repo Workflow

Standard workflow for implementing a task in a single repository.

## Steps

1. **Clarify** — Understand the task. Ask questions if requirements are ambiguous.
2. **Scan** — Run `/architecture-scan` to understand the codebase structure, modules, and dependencies.
3. **Plan** — Run `/implementation-plan` to produce a concrete plan with affected files, order, and risks.
4. **Implement** — Write the code following the plan. Apply standards from `.claude/rules/review.md`.
5. **Review** — Run `/review-branch` to get a structured review with severity-ranked issues.
6. **Remediate** (if needed) — Run `/remediation-plan` to convert review findings into a prioritized fix plan.
7. **Fix** — Run `/fix-branch` to apply targeted fixes.
8. **Validate** — Run tests, check for regressions, verify the implementation meets requirements.
9. **PR** — Create a pull request with a clear summary.

## When to skip steps

- Trivial changes (typos, config): skip scan and plan, go straight to implement.
- Already reviewed: skip review, go to PR.
- No issues found in review: skip remediate and fix.

## Key principle

Each step produces an artifact that feeds the next step. Do not skip steps for non-trivial changes.
