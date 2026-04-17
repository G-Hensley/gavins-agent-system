# Agent Memory

Persistent learnings per agent. Each subdirectory (e.g. `backend-engineer/`, `code-explorer/`) holds memory files written by that agent across sessions. Agents read their own memory at session start and append to it as they work.

## Layout

```
agent-memory/
  README.md                    # this file (the only tracked file)
  <agent-name>/
    MEMORY.md                  # index of memories with one-line descriptions
    <topic>.md                 # one file per learned fact, feedback, or context
```

`MEMORY.md` is an index, not a memory. Each entry is one line linking to a memory file: `- [Title](file.md) — one-line hook`.

Memory files use frontmatter:

```markdown
---
name: <memory name>
description: <one-line description used to decide relevance>
type: <user | feedback | project | reference>
---

<memory content>
```

See `~/.claude/CLAUDE.md` "auto memory" section for the full memory protocol.

## Why this directory is git-ignored

Agent memories accumulate per-machine and frequently contain proprietary or project-specific context — internal service names, customer references, architectural details, work-in-progress investigations. None of that belongs in a public repository.

Only this README is tracked. Everything else under `agent-memory/` is excluded by `.gitignore` so:
- `scripts/install.sh` still has a symlink target (`~/.claude/agent-memory` → here)
- Memories grow naturally on each machine without polluting the repo
- New users cloning the repo get an empty memory store, ready to be populated

If you want cross-machine memory sync, keep memories in a **separate private repo** symlinked from `~/.claude/agent-memory/` instead.
