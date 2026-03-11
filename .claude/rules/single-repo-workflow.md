# Single-Repo Workflow

Standard workflow for implementing a task in a single repository.

## Steps

1. **Clarify** — Understand the task. Ask questions if requirements are ambiguous.
2. **Scan** — Run `/architecture-scan` to understand the codebase structure, modules, and dependencies.
3. **Plan** — Run `/implementation-plan` to produce a concrete plan with affected files, order, and risks.
4. **Implement** — Write the code following the plan. Apply standards from `.claude/rules/review.md`.
5. **Test** — Run `/generate-tests` to write tests for changed code (happy path, edge cases, error cases).
6. **Review** — Run `/review-branch` to get a structured review with severity-ranked issues.
7. **Remediate** (if needed) — Run `/remediation-plan` to convert review findings into a prioritized fix plan.
8. **Fix** — Run `/fix-branch` to apply targeted fixes.
9. **PR** — Run `/create-pr` to push the branch and create a pull request with structured description.
10. **Feedback** — Run `/address-feedback <PR number>` to read reviewer comments, categorize, and fix.
11. **QA** — If QA finds bugs, run `/address-feedback from QA` or `/fix-branch <QA bugs>` to fix and push.

## When to skip steps

- Trivial changes (typos, config): skip scan and plan, go straight to implement.
- Already reviewed: skip review, go to PR.
- No issues found in review: skip remediate and fix.
- No test changes needed: skip test step.

## Key principle

Each step produces an artifact that feeds the next step. Do not skip steps for non-trivial changes.
