---
name: agent-memory-reaper
description: Keep `agent-memory/` synchronized with `agents/` — finds agents without a memory directory (silent memory loss) and memory directories without an agent (dead weight), reports both, and optionally reconciles. Use after adding, renaming, or removing an agent, or on a monthly cadence.
---

# agent-memory-reaper

A small repo-hygiene skill that enforces the one-to-one invariant between `agents/<name>.md` and `agent-memory/<name>/`. Drift between the two surfaces in three ways: (a) a new agent with no memory dir silently starts each session with a blank slate and can't record feedback, (b) a renamed agent writes memory to a dir that future runs won't read from, (c) a deleted agent leaves its memory behind forever.

## Why this beats the current workaround

At the time of writing, `agent-memory/frontend-engineer/` is missing — every other agent has a memory dir but this one doesn't. This kind of drift is invisible until the agent would have benefited from recalling feedback. Nothing in the repo flags it. `scripts/validate.sh` has 236 checks but none of them compare `agents/` against `agent-memory/`.

## Behavior

```
$ agent-memory-reaper

Missing memory dirs (agent exists, memory does not):
  - frontend-engineer  → agent-memory/frontend-engineer/MEMORY.md

Orphaned memory dirs (memory exists, agent does not):
  (none)

Run `agent-memory-reaper --fix` to create missing dirs with a stub MEMORY.md.
Run `agent-memory-reaper --archive` to move orphaned dirs to agent-memory/.archive/<name>-<date>/.
```

## Fix mode

```
$ agent-memory-reaper --fix
Created: agent-memory/frontend-engineer/MEMORY.md (stub)
```

The stub MEMORY.md should be:

```markdown
# Memory Index — frontend-engineer

No memories yet. This file serves as the index for memory records. Each record lives in its own `.md` file in this directory and is linked here with a one-line description.

## Records

- (none)
```

## Archive mode

Orphaned memory dirs are moved to `agent-memory/.archive/<name>-YYYY-MM-DD/` rather than deleted. Keeps the repo clean while preserving history in case an agent is re-added.

## Reference implementation sketch

```bash
#!/usr/bin/env bash
# scripts/hooks/agent-memory-reaper.sh

cd "$(git rev-parse --show-toplevel)"

comm -23 \
  <(ls agents/ | sed 's/\.md$//' | sort) \
  <(ls agent-memory/ 2>/dev/null | sort) \
  > /tmp/missing-memory

comm -13 \
  <(ls agents/ | sed 's/\.md$//' | sort) \
  <(ls agent-memory/ 2>/dev/null | grep -v '^\.archive$' | sort) \
  > /tmp/orphaned-memory

echo "Missing memory dirs: $(wc -l < /tmp/missing-memory)"
cat /tmp/missing-memory | sed 's/^/  - /'
echo "Orphaned memory dirs: $(wc -l < /tmp/orphaned-memory)"
cat /tmp/orphaned-memory | sed 's/^/  - /'

# --fix, --archive branches follow
```

## Integration

- Add as a check in `scripts/validate.sh` (Check 10: agent/memory parity)
- Expose as `/agent-memory-reaper` slash command for ad-hoc runs
- Optionally run in the `validate.sh` CI step to block PRs that add an agent without a memory dir

## Success criteria

- On a clean repo (every agent has a memory dir, no orphans), runs silent with exit 0
- Detects the current `frontend-engineer` gap and offers to fix it in one command
- Fix mode is idempotent — re-running does nothing
