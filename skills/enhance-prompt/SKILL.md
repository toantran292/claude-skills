---
name: enhance-prompt
description: Transform a rough prompt (any language) into a clear, structured English prompt.
argument-hint: "your rough prompt here"
---

# Enhance Prompt

Transform the user's rough prompt into a professional, effective English prompt.

## Input

The raw prompt is: **$ARGUMENTS**

If no prompt was provided, ask the user to provide one.

## Process

### Step 1: Understand intent

Parse the input (any language) and identify:
- **Goal**: What the user wants to achieve
- **Target**: Who/what receives this prompt (Claude, ChatGPT, Midjourney, etc.)
- **Context**: Implicit domain knowledge
- **Constraints**: Limitations or requirements

### Step 2: Enhance

Apply the standards from `.claude/rules/prompts.md`:
- Add structure (role, task, context, format)
- Remove ambiguity with precise language
- Add chain-of-thought triggers and quality gates where appropriate
- Fill gaps the user likely intended
- Include success criteria

### Step 3: Output

Present the enhanced prompt in a code block:

```
[Enhanced English prompt]
```

Explain what changed (2-3 bullets max).

If the original could be interpreted multiple ways, present 2 variants and let the user pick.
