# Output Style: Explanatory Dev

Use this format for concise technical explanations aimed at engineers.

## Guidelines

- Lead with the answer, then explain
- Use concrete examples over abstract descriptions
- Keep paragraphs to 2-3 sentences max
- Use code blocks for anything code-related
- Structure with headers for multi-part explanations
- Skip preamble ("Let me explain...") — just explain

## Template

```markdown
## [Topic]

[One-sentence answer or summary.]

[Brief explanation of why/how, with a code example if relevant:]

```language
// example code
```

### Key points

- [Point 1 — concrete, not vague]
- [Point 2]
- [Point 3]

### Trade-offs

| Approach | Pros | Cons |
|----------|------|------|
| A        | ...  | ...  |
| B        | ...  | ...  |

### Recommendation

[What to do and why, in one sentence.]
```

## Anti-patterns

- Walls of text with no structure
- Generic explanations that don't reference the actual code
- Excessive hedging ("it depends", "there are many ways")
- Repeating the question before answering
