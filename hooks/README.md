# Hooks

Example hook scripts for automating tasks around Claude Code skill execution.

## What are hooks?

Hooks are shell scripts that run automatically in response to events. Claude Code supports hooks that fire before or after tool executions.

## Files

| Hook | Purpose |
|------|---------|
| `after-review.example.sh` | Post-processing after a code review (e.g. save report) |
| `after-fix.example.sh` | Post-processing after fixes are applied (e.g. run tests) |
| `notify.example.sh` | Send notifications (Slack, email) after events |
| `protect-critical-files.example.sh` | Block edits to protected files |

## Usage

1. Copy the example to your project's `.claude/hooks/` directory
2. Remove the `.example` suffix
3. Configure the hook in your `.claude/settings.json`:

```json
{
  "hooks": {
    "after_tool_use": [
      {
        "matcher": "Edit",
        "command": ".claude/hooks/protect-critical-files.sh $FILE_PATH"
      }
    ]
  }
}
```

4. Make the script executable: `chmod +x .claude/hooks/<script>.sh`

## Notes

- Hooks run in the project's root directory
- A non-zero exit code from a hook will block the action (for "before" hooks)
- Keep hooks fast — they run synchronously
- See [Claude Code hooks documentation](https://code.claude.com/docs/en/hooks) for full reference
