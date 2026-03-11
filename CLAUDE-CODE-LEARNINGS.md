# Claude Code — Learnings & Tips

A personal reference for things I've learned about using Claude Code.

---

## Permissions & Bash Prompts

Claude Code prompts for approval before running bash commands. Here's how to control that behavior.

### Permission Modes

Set via the mode selector in the Cursor UI, or in a settings file with `"defaultMode"`:

| Mode | Behavior |
|------|----------|
| `ask` (default) | Prompts before each bash command |
| `acceptEdits` | Auto-approves file edits; still asks for bash |
| `bypassPermissions` | Skips all prompts (use with caution) |

### Settings Files

| File | Scope |
|------|-------|
| `~/.claude/settings.json` | User-wide (applies to all projects) |
| `.claude/settings.json` | Project-shared (can be checked into git) |
| `.claude/settings.local.json` | Local overrides (git-ignored) |

### Pre-approve Commands with Allow Rules

Add glob patterns to `~/.claude/settings.json` (or the project-level equivalent):

```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(ls *)",
      "Bash(npm run *)"
    ]
  }
}
```

- Patterns use `*` as a wildcard
- `Bash(ls *)` matches `ls -la` but NOT `lsof` (space matters)
- Use `Bash(ls*)` (no space) to match both

### "Always Allow" During a Session

When prompted, clicking **Always allow** permanently adds that command to the project's allow list — no manual settings edit needed.

### Deny Rules

Block specific commands while allowing others:

```json
{
  "permissions": {
    "allow": ["Bash"],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)"
    ]
  }
}
```

Rule evaluation order: **deny → ask → allow** (first match wins).

### Precedence (highest → lowest)

1. Managed/enterprise settings
2. CLI flags (`--allowedTools`, `--dangerously-skip-permissions`)
3. `.claude/settings.local.json`
4. `.claude/settings.json` (project)
5. `~/.claude/settings.json` (user)

### View Active Rules

Run `/permissions` inside Claude Code to see all active rules and their sources.

---

## Tips

- Start with `"defaultMode": "acceptEdits"` + a short allow list — good balance of speed and safety.
- Never use `bypassPermissions` on shared or production environments.
