---
name: generate-tests
description: Generate tests for changed or untested code on the current branch.
argument-hint: "file or module to test (optional, defaults to changed files on branch)"
---

# Generate Tests

Write tests for code that was changed or is missing test coverage.

## Input

Target: **$ARGUMENTS**

If no target provided, detect changed files on the current branch vs base branch.

## Process

### Step 1: Identify what to test

1. Get changed files:
```bash
git diff --name-only origin/$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")...HEAD
```

2. For each changed file, check if a corresponding test file exists.
3. Prioritize: files with no tests > files with partial coverage > files with full coverage.

### Step 2: Analyze existing test patterns

Before writing tests, understand the project's conventions:
- Test framework (Jest, Mocha, RSpec, pytest, Go testing, etc.)
- Test file location and naming (`*.test.ts`, `*.spec.ts`, `*_test.go`, `test_*.py`)
- Test style (BDD, TDD, table-driven, etc.)
- Mocking patterns (what's mocked, what's real)
- Fixtures and factories

Follow existing patterns exactly — do not introduce new test conventions.

### Step 3: Write tests

For each file needing tests:

1. **Read the source code** and understand the public API
2. **Write tests** covering:
   - Happy path (normal inputs, expected outputs)
   - Edge cases (empty, null, boundary values, large inputs)
   - Error cases (invalid inputs, failures, exceptions)
   - Integration points (if the code calls external services, test the interaction)
3. **Follow project conventions** from Step 2
4. **Apply standards** from `.claude/rules/review.md` (testing section)

### Step 4: Verify

1. Run the test suite to confirm new tests pass:
```bash
[detected test command]
```

2. Confirm no existing tests broke.
3. If tests fail, fix them before presenting.

## Output

```
## Tests Generated

### New test files
| File | Tests | Covers |
|------|-------|--------|
| ...  | X tests | [source file] |

### Added to existing test files
| File | Tests added | Covers |
|------|------------|--------|
| ...  | X tests    | [new code paths] |

### Coverage summary
- Files changed: X
- Files with tests: Y
- Tests written: Z
- All tests passing: yes/no
```

## Limitations

- Does not measure code coverage percentages — relies on heuristic analysis
- Follows existing test patterns; will not set up a test framework from scratch
- Integration/E2E tests require environment setup that may not be available
