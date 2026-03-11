# References

Claude Code documentation that influenced this toolkit's architecture.

## Primary references

### [Skills](https://code.claude.com/docs/en/skills)

Defines the SKILL.md format, `$ARGUMENTS` variable, YAML frontmatter conventions, and how Claude Code discovers and executes skills. Directly shaped our skill structure.

### [Memory / CLAUDE.md](https://code.claude.com/docs/en/memory)

Explains how Claude Code uses CLAUDE.md for project-level conventions and `.claude/rules/` for reusable rule files. Shaped our rules extraction pattern — standards live in `.claude/rules/` and are referenced by skills.

### [Sub-agents](https://code.claude.com/docs/en/sub-agents)

Describes how to define specialized agents with focused responsibilities. Shaped our `agents/` directory with role-based markdown definitions.

### [Hooks guide](https://code.claude.com/docs/en/hooks-guide)

Explains hook lifecycle, configuration, and use cases. Shaped our `hooks/` directory with practical examples.

### [Output styles](https://code.claude.com/docs/en/output-styles)

Describes how to standardize Claude Code output formats. Shaped our `.claude/output-styles/` directory.

### [Best practices](https://code.claude.com/docs/en/best-practices)

Key principles applied:
- Keep skills focused and single-responsibility
- Reference shared rules instead of duplicating
- Keep instructions concise
- Separate concerns between skills, rules, agents, and hooks

### [Common workflows](https://code.claude.com/docs/en/common-workflows)

Influenced the single-repo and multi-repo workflow designs. Patterns like "scan → plan → implement → review → fix" come from common engineering workflows adapted for Claude Code.

## Secondary references

### [Features overview](https://code.claude.com/docs/en/features-overview)

General understanding of Claude Code capabilities. Informed which features to leverage (skills, agents, hooks) vs which to avoid (complex automation).

### [Settings](https://code.claude.com/docs/en/settings)

Understanding of `.claude/settings.json` structure for hook configuration.

### [Plugins](https://code.claude.com/docs/en/plugins)

Understanding of the plugin model. This toolkit uses skills (not plugins) but the plugin architecture informed separation of concerns.

### [How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works)

Understanding of the execution model. Informed the decision to output to stdout rather than file-based workflows.
