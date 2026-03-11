# Code Review Standards

Apply these standards when reviewing or writing code.

## SOLID Principles

- **Single Responsibility**: Each function/class does one thing. If it needs "and" to describe, split it.
- **Open/Closed**: Extend via abstraction, not modifying existing code.
- **Liskov Substitution**: Subtypes must be substitutable without breaking behavior.
- **Interface Segregation**: Small, focused interfaces. No unused method dependencies.
- **Dependency Inversion**: Depend on abstractions. Inject dependencies.

## Clean Code

- Methods under 20 lines. Extract if longer.
- Intention-revealing names — no abbreviations except loop vars.
- No magic numbers/strings — use named constants.
- Max 2 nesting levels. Use early returns.
- No dead code, commented-out code, or TODOs without tickets.
- Max 3 parameters per function. Use objects for more.

## Security

- Never trust user input — validate at system boundaries.
- Parameterized queries only — no string concatenation for SQL.
- Whitelist allowed fields — no mass assignment.
- Redact sensitive data in logs and errors.
- Auth checks on every endpoint.
- No secrets in code — use env vars or secret managers.

## Performance

- No N+1 queries — eager load, join, or batch.
- Index columns used in WHERE, JOIN, ORDER BY.
- Paginate list endpoints — no unbounded results.
- Cache expensive computations.
- Stream large datasets — avoid loading all into memory.

## ACID (database operations)

- **Atomicity**: Wrap related operations in transactions.
- **Consistency**: Use DB constraints, not just app logic.
- **Isolation**: Appropriate isolation levels. Watch for race conditions.
- **Durability**: Confirm critical writes.

## Testing

- Cover: happy path, edge cases, error cases.
- Tests must be independent, deterministic, fast.
- Descriptive test names explaining scenario and expectation.
- Mock external dependencies, not internal logic.

## Review severity levels

- **Critical**: Must fix before production. Security holes, data loss, crashes.
- **Major**: Should fix before merge. Bugs, performance issues, missing validation.
- **Minor**: Fix when convenient. Style, naming, minor improvements.
- **Suggestions**: Optional improvements. Alternative approaches, nice-to-haves.
