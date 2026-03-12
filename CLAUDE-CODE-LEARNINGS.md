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

## Git Branches

### What's a Branch?

A branch is like a parallel copy of your project where you can make changes without affecting the main version. Claude Code (mobile and desktop) often creates branches automatically when making bigger changes.

### Fetch vs. Pull

| Command | What it does |
|---------|-------------|
| `git fetch` | Downloads info about remote branches — does **not** change your files |
| `git pull` | Downloads **and** applies changes to your current branch |

Run `git fetch --all` to see any new branches that exist on GitHub but not yet on your computer.

### Listing Branches

```bash
git branch -a
```

- Branches starting with `remotes/origin/` live on GitHub (remote)
- The `*` marks your current branch

### Switching Branches

```bash
git checkout branch-name
```

- Safe to do when your working tree is **clean** (no unsaved/uncommitted changes)
- Switches all your project files to match that branch
- Switch back to main anytime: `git checkout main`

### Document Before You Switch

If you want to save notes or edit files, do it on `main` **before** switching branches — that way your notes end up where you want them.

---

## Tips

- Start with `"defaultMode": "acceptEdits"` + a short allow list — good balance of speed and safety.
- Never use `bypassPermissions` on shared or production environments.
