---
name: path-canonicalizer
description: One-shot migration command that detects duplicate project identities in `~/.claude/projects/` (old pre-Projects/ paths vs canonical Projects/ paths), merges their session memory and file history, and retires the old slug. Use once after a workspace reorganization, or periodically when Claude Code's "recent projects" list keeps surfacing old paths.
---

# path-canonicalizer

Fixes the specific problem where the same logical repository has two tracked identities in `~/.claude/projects/` because it was moved on disk without migrating its Claude Code state.

## The specific problem this solves

Gavin's top-level `CLAUDE.md` declares the canonical layout as `C:\Users\Gavin Hensley\Projects\{Apisec,Gavins-Projects,Tampertantrum}\...`. But `~/.claude/projects/` currently contains both pre-migration and post-migration slugs for the same repos:

| Logical repo | Old slug | New slug |
|---|---|---|
| desk-agent | `C--Users-Gavin-Hensley-Apisec-desk-agent` | `C--Users-Gavin-Hensley-Projects-Apisec-desk-agent` |
| baloo | `C--Users-Gavin-Hensley-Apisec-baloo` | (not yet) |
| gavins-agent-system | `C--Users-Gavin-Hensley-Gavins-Projects-gavins-agent-system` | (not yet) |
| mothership | `C--Users-Gavin-Hensley-Gavins-Projects-mothership` | (not yet) |

Each slug holds its own `memory/`, `file-history/`, and session jsonl logs. Memory written in one identity is invisible to the other. Opening a session from the old path creates a third identity over time.

## Behavior

```
$ path-canonicalizer

Detected duplicate identities:
  desk-agent:
    old: C--Users-Gavin-Hensley-Apisec-desk-agent       (4 sessions, 8 memory files, 3 file-history entries)
    new: C--Users-Gavin-Hensley-Projects-Apisec-desk-agent  (2 sessions, 2 memory files, 0 file-history entries)

Sessions-only identities at non-canonical paths:
  baloo:                      C--Users-Gavin-Hensley-Apisec-baloo
  gavins-agent-system:        C--Users-Gavin-Hensley-Gavins-Projects-gavins-agent-system
  mothership:                 C--Users-Gavin-Hensley-Gavins-Projects-mothership

Canonical workspace root: C:\Users\Gavin Hensley\Projects\

Run `path-canonicalizer --plan` to see the exact file operations that would merge these.
Run `path-canonicalizer --apply` to execute the merge (backs everything up first).
```

## Plan output

```
$ path-canonicalizer --plan

desk-agent merge:
  - For each file in old/memory/ not present in new/memory/: copy to new/memory/
  - For each file in old/memory/ present in new/memory/: flag as conflict, require --resolve
  - Archive old slug: mv ~/.claude/projects/<old>/ ~/.claude/projects/.archive/<old>-<date>/
  - Next session from the new path will see merged memory.

baloo migration (no canonical-path sessions yet):
  - Rename slug: ~/.claude/projects/C--Users-Gavin-Hensley-Apisec-baloo/
                → ~/.claude/projects/C--Users-Gavin-Hensley-Projects-Apisec-baloo/
  - Next session must open from C:\Users\Gavin Hensley\Projects\Apisec\baloo\ or
    the rename will re-invert. Also confirm the actual repo lives at the canonical path.
```

## Safety

- `--plan` is read-only. No writes until `--apply` is passed.
- Every operation is preceded by a full backup of `~/.claude/projects/` to `~/.claude/projects/.archive/<date>-pre-canonicalize/`.
- Memory-file conflicts (same filename in both identities with differing content) abort the merge; surface as a diff and require `--resolve=ours|theirs|manual`.
- `--apply` refuses to run if the canonical-path repo on disk does not exist. (i.e. it won't retire a slug whose "new path" is fake.)

## Integration

- Ships as a script `scripts/path-canonicalizer.sh` and a slash command `/path-canonicalizer`
- NOT run automatically on a schedule — one-shot migration tool
- Include in onboarding docs as a step when moving the workspace root

## Success criteria

- After running, `ls ~/.claude/projects/` shows only one slug per logical repo, all pointing at the canonical workspace root
- Opening a session from the canonical path picks up memory that was written from the old path
- Running again detects no work to do and exits with "All project identities canonical."

## Out of scope

- This command does not move actual repos on disk. If your `desk-agent` clone is still at `C:\Users\Gavin Hensley\Apisec\desk-agent\`, you have to `git mv` it yourself. This command only fixes Claude Code's tracking of identities.
