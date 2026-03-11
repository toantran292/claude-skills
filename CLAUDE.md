# Claude Skills Toolkit

Engineering toolkit for Claude Code — skills, agents, hooks, output styles, and reusable rules.

## Project structure

```
skills/          Focused, single-responsibility skills (SKILL.md per skill)
agents/          Specialized subagent definitions
hooks/           Example hook scripts for automation
.claude/rules/   Reusable rules referenced by skills and agents
.claude/output-styles/  Standardized output formats
docs/            Architecture and usage documentation
examples/        Example outputs and session transcripts
scripts/         Install, relink, and validation scripts
```

## Conventions

- Skills use kebab-case: `<verb>-<noun>` (e.g. `review-branch`, `enhance-prompt`)
- Each skill has exactly one `SKILL.md` with YAML frontmatter
- Skills must have a single responsibility — one skill, one job
- Skills reference shared rules in `.claude/rules/` instead of embedding long instructions
- `$ARGUMENTS` is the user input variable in skills
- `disable-model-invocation: true` only on skills that orchestrate other skills
- Agents are markdown files in `agents/` defining role, responsibilities, and boundaries
- Output styles in `.claude/output-styles/` define reusable formats for artifacts
- Hook examples in `hooks/` are `.example.sh` files — not active by default

## Commit conventions

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
- **Scope**: optional, identifies the affected area (e.g. `feat(skills): ...`, `fix(relink): ...`)
- **Breaking changes**: add `!` after type/scope (e.g. `feat!: ...`) or `BREAKING CHANGE:` footer
- NEVER include `Co-Authored-By` trailers from Claude or any AI agent in commits

## Quality standards

All code-related skills follow the standards defined in `.claude/rules/review.md`:
- SOLID principles
- Clean Code practices
- Security-first approach
- Performance awareness
- ACID compliance for database operations

## Workflow modes

- **Single-repo**: See `.claude/rules/single-repo-workflow.md`
- **Multi-repo**: See `.claude/rules/multi-repo-workflow.md`

## Development

```bash
# Validate repository structure
bash scripts/validate.sh

# Re-symlink skills after changes
bash scripts/relink.sh
```
