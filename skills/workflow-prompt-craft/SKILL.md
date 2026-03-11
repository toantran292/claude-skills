---
name: workflow-prompt-craft
description: Full prompt optimization workflow — enhance any rough idea (any language) into a professional prompt, execute it, evaluate the result, and iterate until perfect.
argument-hint: "your rough idea in any language"
disable-model-invocation: true
---

# Workflow: Prompt Craft

Turn any rough idea — in any language — into a perfectly crafted prompt, execute it, and iterate until the result is excellent.

## Input

The raw idea is: **$ARGUMENTS**

If no idea was provided, ask the user to provide one.

## Workflow

### Phase 1: Enhance

Run `/enhance-prompt $ARGUMENTS`

This transforms the rough idea into a professional, well-structured English prompt.

Present the enhanced prompt to the user and ask:

> **Does this prompt capture what you want? You can:**
> 1. Approve and proceed to execution
> 2. Adjust — tell me what to change
> 3. See alternative variants

If the user wants adjustments, refine and present again. Do NOT proceed until the user approves.

### Phase 2: Execute

Once the user approves the prompt, run `/execute-prompt <the approved prompt>`

Present the full result to the user.

### Phase 3: Evaluate

After delivering the result, ask the user:

> **How's the result?**
> 1. Perfect — we're done
> 2. Close but needs tweaks — tell me what to adjust
> 3. Not what I wanted — let's refine the prompt and try again

### Phase 4: Iterate (if needed)

Based on user feedback:

**Option 2 (tweaks):** Apply the requested changes directly to the output. Then return to Phase 3.

**Option 3 (retry):** Analyze what went wrong:
- Was the prompt unclear? → Refine the prompt and return to Phase 1
- Was the execution flawed? → Re-execute with better approach and return to Phase 2

Continue iterating until the user is satisfied (Option 1).

### Phase 5: Summary

When the user confirms they're happy, present:

```
## Prompt Craft — Complete

**Original idea:** <the raw input>
**Final prompt:** <the approved prompt>
**Iterations:** <number of cycles>
**Result:** <brief description of what was produced>
```

If the user might want to reuse the prompt, suggest saving it:

> Want me to save this prompt for future use? I can create a file at a location of your choice.
