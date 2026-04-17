Check the self-improvement backlog and help build the most valuable suggestion.

1. Read all `*.md` files under `~/.claude/improvements/` (recursively, excluding `README.md`). Suggestions live in subdirs classifying the kind — currently `system/`, and `skills/` or `agents/` if present.
2. If empty, say "No improvement suggestions logged yet. I'll log suggestions as I notice gaps during work."
3. If files exist, present them ranked by impact:
   - Summarize each suggestion in one line, prefixed with its subdir (e.g. `[system]`, `[skills]`)
   - Recommend which to build first and why
4. When the user picks one, use the `skill-creator` skill to build it following all standards (under 200 lines, proper frontmatter, has Process and What NOT to Do sections, references linked)
5. After building, delete the suggestion file from `improvements/`
6. Run `bash scripts/validate.sh` to verify the catalog is still consistent
