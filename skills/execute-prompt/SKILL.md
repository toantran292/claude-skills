---
name: execute-prompt
description: Execute a well-crafted prompt and deliver the result. Handles any prompt type — code generation, writing, analysis, design, etc.
argument-hint: "the prompt to execute (or path to a file containing the prompt)"
---

# Execute Prompt

Execute the given prompt with maximum quality and deliver the result.

## Input

The prompt to execute is: **$ARGUMENTS**

If no prompt was provided, ask the user to provide one.

If the argument looks like a file path, read the file and use its content as the prompt.

## Process

### Step 1: Analyze the prompt

Before executing, identify:
- **Type**: What kind of output is expected? (code, text, analysis, design, plan, etc.)
- **Scope**: How large/complex is the request?
- **Tools needed**: Which tools will be required? (file I/O, web search, bash, etc.)
- **Success criteria**: What makes a good result for this specific prompt?

### Step 2: Execute with precision

Follow the prompt's instructions exactly. Key principles:

**Faithfulness:**
- Do exactly what the prompt asks — no more, no less
- Respect all constraints, formats, and specifications stated in the prompt
- If the prompt specifies a persona/role, adopt it fully

**Quality:**
- Apply domain expertise relevant to the prompt's subject matter
- Use appropriate tools (search, read, write, bash) as needed
- For code: write production-quality, tested code
- For writing: match the requested tone, style, and audience
- For analysis: be thorough, evidence-based, and structured

**Completeness:**
- Deliver ALL requested outputs, not just part of them
- If the prompt asks for files, create them
- If the prompt asks for explanations, provide them
- Handle edge cases mentioned in the prompt

### Step 3: Self-review

Before presenting the result, verify:
- [ ] All requirements from the prompt are addressed
- [ ] Output format matches what was requested
- [ ] Quality meets professional standards
- [ ] No hallucinated information or made-up data
- [ ] Code compiles/runs if applicable

### Step 4: Deliver

Present the result clearly. If the output is:
- **Code**: Write to files and show key highlights
- **Text/Writing**: Present in clean formatting
- **Analysis**: Use structured sections with key findings first
- **Mixed**: Organize by type with clear sections

After delivering, provide a brief summary:
- What was produced
- Any assumptions made
- Suggestions for improvement (only if genuinely useful)
