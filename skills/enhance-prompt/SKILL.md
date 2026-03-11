---
name: enhance-prompt
description: Transform a rough prompt (Vietnamese or English) into a well-structured, effective English prompt. Use when user wants to improve or translate their prompt.
argument-hint: "your rough prompt here"
disable-model-invocation: true
---

# Enhance Prompt

Transform the user's rough prompt into a professional, effective English prompt.

## Input

The raw prompt is: **$ARGUMENTS**

If no prompt was provided, ask the user to provide one.

## Process

### Step 1: Understand intent

Parse the raw prompt (Vietnamese or English) and identify:
- **Goal**: What does the user actually want to achieve?
- **Target audience**: Who/what will receive this prompt? (ChatGPT, Claude, Midjourney, Stable Diffusion, DALL-E, a colleague, a system prompt, etc.)
- **Context**: Any implicit context or domain knowledge
- **Constraints**: Any limitations or requirements mentioned

### Step 2: Enhance using these principles

**Clarity:**
- Remove ambiguity — be specific about what you want
- Replace vague words with precise ones
- State the desired output format explicitly

**Structure:**
- Lead with the role/persona if applicable ("You are a...")
- State the task clearly in one sentence
- Provide context and constraints
- Specify output format and length
- Include examples if helpful (few-shot)

**Effectiveness:**
- Add chain-of-thought triggers ("Think step by step", "Before answering, consider...")
- Add quality gates ("Double-check your work", "If unsure, say so")
- Add negative constraints where useful ("Do NOT include...", "Avoid...")
- Set the tone and style explicitly

**Completeness:**
- Fill in gaps the user likely intended but didn't state
- Add edge case handling if relevant
- Include success criteria — what does a good response look like?

### Step 3: Output

Present the enhanced prompt in a clean code block the user can copy-paste.

Format:
```
[The enhanced English prompt here]
```

Then briefly explain (2-3 bullet points max) what you changed and why.

If the original prompt could be interpreted multiple ways, present 2 variants and let the user pick.
