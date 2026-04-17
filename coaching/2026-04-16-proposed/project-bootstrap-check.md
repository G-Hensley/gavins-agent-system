---
name: project-bootstrap-check
description: Verify a project is ready for deep work at session start — checks for CLAUDE.md at repo root, INVENTORY.md listing, canonical path, and .claude/agents presence. Emits a one-line warning for each missing piece so the session doesn't start with hidden context debt. Use automatically at the start of any Claude Code session when cwd is a git repo.
---

# project-bootstrap-check

A short session-opener skill (or a SessionStart hook) that catches the three cheapest-to-prevent context failures before any real work begins.

## Why this beats the current workaround

Right now, when Gavin opens a Claude Code session in a project without a CLAUDE.md (e.g. mothership), the session begins with him pasting the full spec into the first user message — sometimes thousands of tokens, repeated every session. By the time the pattern is noticed, the session has already committed to a specific interpretation of the spec that could have been encoded once in CLAUDE.md. Similarly, opening a session from a pre-migration path (`C:\Users\Gavin Hensley\Apisec\...`) silently creates a second memory identity for the same repo.

## The three checks

1. **CLAUDE.md presence.** Look for `CLAUDE.md` at `cwd` root. If absent, warn: *"No CLAUDE.md in this repo. Consider invoking the `project-scaffolding` skill before deep work."*
2. **Canonical path.** Read the top-level workspace root from Cowork/Claude Code settings (default: `C:\Users\Gavin Hensley\Projects\`). If `cwd` is not under it (e.g. `C:\Users\Gavin Hensley\Apisec\desk-agent\`), warn: *"Non-canonical path. Canonical location for this repo is under `Projects/`. Memory/history from this path will not merge with canonical-path sessions."*
3. **Global install health.** Check that `~/.claude/CLAUDE.md` is a live symlink (not a regular file, not missing, not `.bak`). If broken, warn: *"Global agent system not installed — run `/install-doctor`. Project-local `.claude/` will still work."*

## Output format

Emit at most one line per failing check. If all pass, emit nothing. Do not prompt the user for a decision; just warn and let them choose.

## Integration

Option A (preferred) — add a SessionStart hook in `config/hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "REPO_DIR/scripts/hooks/project-bootstrap-check.sh",
            "timeout": 3
          }
        ]
      }
    ]
  }
}
```

Option B — add it as a skill the `skill-router` invokes on every "new task" signal.

## Reference implementation sketch

```bash
#!/usr/bin/env bash
# scripts/hooks/project-bootstrap-check.sh

cwd="$(pwd)"
claude_dir="$HOME/.claude"
canonical_root="$HOME/Projects"   # or read from settings

# 1. CLAUDE.md presence
[ -f "$cwd/CLAUDE.md" ] || echo "warn: no CLAUDE.md at $cwd — run project-scaffolding before deep work"

# 2. Canonical path
case "$cwd" in
  "$canonical_root"/*) ;;
  *) echo "warn: $cwd is not under $canonical_root (canonical workspace). Sessions here create a separate memory identity." ;;
esac

# 3. Global install
if [ ! -L "$claude_dir/CLAUDE.md" ] && [ -f "$claude_dir/CLAUDE.md.bak" ]; then
  echo "warn: ~/.claude/CLAUDE.md is missing but .bak exists — run /install-doctor"
fi
```

## Success criteria

- Opening a fresh session in a repo that already has CLAUDE.md + is under `Projects/` + install is healthy produces zero warnings and adds no latency
- Opening a session in `mothership/` (no CLAUDE.md) prints one warning
- Opening a session in `C:\Users\Gavin Hensley\Apisec\desk-agent\` (old path) prints one warning
- Opening any session while `~/.claude/CLAUDE.md.bak` exists but `CLAUDE.md` does not prints one warning
