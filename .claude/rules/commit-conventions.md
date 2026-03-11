# Commit Conventions

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
- **Scope**: optional, identifies the affected area (e.g. `feat(api): ...`, `fix(auth): ...`)
- **Breaking changes**: add `!` after type/scope (e.g. `feat!: ...`) or `BREAKING CHANGE:` footer
- NEVER include `Co-Authored-By` trailers from Claude or any AI agent in commits
