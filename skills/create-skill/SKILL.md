---
name: create-skill
description: Meta-skill that scaffolds a new Claude Code skill or workflow, following project conventions, and updates the README.
argument-hint: "description of the skill you want to create"
---

# Create Skill

Scaffold a new Claude Code skill or workflow for this project based on the user's description.

## Input

The skill idea is: **$ARGUMENTS**

If no description was provided, ask the user to describe what skill they want to create.

## Process

### Step 1: Classify and name

Based on the description, determine:

- **Type**: Is this a **skill** (standalone, does one thing) or a **workflow** (orchestrates multiple skills)?
- **Name**: Choose a kebab-case name following verb-noun pattern:
  - Skills: `<verb>-<noun>` (e.g. `review-branch`, `enhance-prompt`, `fix-branch`)
  - Workflows: `workflow-<verb>-<noun>` (e.g. `workflow-review-fix`, `workflow-prompt-craft`)

Present the proposed name and type to the user for confirmation before proceeding.

### Step 2: Scaffold the SKILL.md

Create `${CLAUDE_SKILL_DIR}/../<skill-name>/SKILL.md` with this structure:

```markdown
---
name: <skill-name>
description: <one-line description>
argument-hint: "<example argument>"
disable-model-invocation: true  # Only if it calls other skills via /skill-name
---

# <Title>

<Brief description of what this skill does.>

## Input

The input is: **$ARGUMENTS**

If no input was provided, ask the user to provide one.

## Process

### Step 1: <first step>
...

### Step 2: <next step>
...
```

Follow these conventions from the project:
- **YAML frontmatter** with name, description, argument-hint
- **`disable-model-invocation: true`** only for workflows that call other skills
- **`$ARGUMENTS`** for user input
- **Imperative voice** for instructions
- **Clear phases/steps** with actionable instructions
- **Output format** specified explicitly where applicable

### Step 3: Update README

Read the current README at `${CLAUDE_SKILL_DIR}/../../README.md`.

Add the new skill/workflow to the appropriate table:
- **Skills table**: if it's a standalone skill
- **Workflows table**: if it's a workflow (prefix `workflow-`)

Also add a usage example under the appropriate section.

Keep the tables sorted alphabetically by name.

### Step 4: Relink

Run the relink script to symlink the new skill immediately:

```bash
bash ${CLAUDE_SKILL_DIR}/../../relink.sh
```

### Step 5: Git branch, commit, and PR

Create a branch, commit, and open a PR for the new skill:

```bash
cd ${CLAUDE_SKILL_DIR}/../..
git checkout -b skill/<skill-name>
git add skills/<skill-name>/SKILL.md README.md
git commit -m "feat: add <skill-name> skill"
git push -u origin skill/<skill-name>
```

Then create a PR using `gh`:

```bash
gh pr create --title "feat: add <skill-name> skill" --body "$(cat <<'EOF'
## Summary
- Add new <type> `<skill-name>`: <one-line description>
- Update README with skill/workflow entry and usage example

## Files
- `skills/<skill-name>/SKILL.md` — skill definition
- `README.md` — updated tables and usage

🤖 Generated with `/create-skill`
EOF
)"
```

Present the PR URL to the user.

### Step 6: Verify

1. Confirm the SKILL.md was created at the correct path
2. Show the user the final SKILL.md content
3. Show the updated README section
4. Confirm the PR was created and show the URL

### Output

```
## Skill Created

**Name:** <skill-name>
**Type:** skill | workflow
**Path:** skills/<skill-name>/SKILL.md
**PR:** <pr-url>

The skill is already linked and available. Use it with:
/<skill-name> <example args>
```
