# Make the system fork-ready for users other than Gavin

## What I Observed

The `feat/genericize-gh-account-guard` branch removed the most actively-broken assumption (the hardcoded `g-hensley` username in `gh-account-guard.sh`) and added `--check-prereqs` to install.sh. Several softer fork-readiness gaps remain:

1. **`CLAUDE.md` is Gavin's personal global instructions** — it lives at the repo root and gets symlinked to `~/.claude/CLAUDE.md`. It contains:
   - APIsec, Cognito SRP, Bedrock-specific stack assumptions
   - "uv only" / "pnpm only" preferences
   - Personal Notion/Cowork pipeline references
   - Encoded-path memory notes specific to `C:\Users\Gavin Hensley\...`
   - The `G-Hensley` GitHub account guidance (now redirected to the config but the rule reads as personal)

2. **`agent-memory/*` contains Gavin's specific learnings** — install.sh symlinks the directory wholesale, so a fork inherits them. Useful for Gavin moving to another machine; misleading for someone else.

3. **`coaching/*` is Gavin-specific dated notes** — README says "not synced" and install.sh DIRS list confirms `coaching` is excluded. Verify this stays the case as new directories are added.

4. **README still leans on "this is Gavin's system"** in copy and tone, even though the install URL was genericized.

## Why It Would Help

- A fork-ready repo is also a portable repo for Gavin himself — the same separation that lets a stranger fork lets Gavin reset a fresh machine cleanly without inheriting stale memory or out-of-date context
- It's the right structural move before sharing the repo more widely (e.g., as an example multi-agent system)
- It clarifies which content is opinionated-Gavin vs. which is genuinely generic — useful even if the system is never forked, because it prevents personal context from creeping into agent skill instructions

## Proposal

Multi-step, can be split across multiple PRs:

### 1. Split CLAUDE.md
- `CLAUDE.md` (in repo) → generic agent-system instructions only: TDD/DRY/YAGNI, file size caps, agent dispatch table, references to the rules and skills
- `CLAUDE.local.md` (gitignored, machine-local) OR `~/.claude/personal-claude.md` (also gitignored, lives in home) → Gavin's preferences: APIsec stack, "uv only", Notion pipeline, encoded-path memory notes
- install.sh symlinks both if present; only the generic one ships in the repo
- Add a `config/personal-claude.md.example` with a template for new users to fill in

### 2. Move agent-memory out of the repo
- `agent-memory/` becomes machine-local, gitignored, not shipped in the repo
- install.sh creates the directory structure on a fresh install but doesn't seed it from the repo
- Existing memory stays where it is on Gavin's machines (no migration needed; just stop tracking it in git going forward)

### 3. Verify coaching exclusion
- Confirm `scripts/install.sh DIRS` does NOT include `coaching`
- Add a comment in install.sh explaining why coaching is excluded
- Add `.gitkeep` to coaching/ if needed

### 4. README pass
- Reframe README intro as "an opinionated portable Claude Code agent system" (not "Gavin's specific environment")
- Move Gavin-specific sections to a separate `docs/personal-context.md` or remove
- Add a "Customizing for your setup" section near the top

### 5. Genericize references in skills
- `skills/pr-check/SKILL.md` historical evidence note mentioning "G-Hensley/gavins-agent-system PR #4" — fine to leave as a verification note, or scrub
- Audit all skills/*.md for any other personal-account references

## Open questions for review

- Should the personal CLAUDE.md live in `~/.claude/personal-claude.md` (alongside symlinks) or in a gitignored file in the repo? Repo-side is more discoverable; home-side is cleaner separation
- Does Gavin want this work at all? The whole repo is named `Gavins-Agent-System`. If it's never going to be forked, this work is YAGNI
- If we DO this, should the repo be renamed to something generic (e.g., `claude-agent-system`)? Big change with ecosystem impact (PR URLs, Dependabot, scheduled-tasks references) — probably not in this round
