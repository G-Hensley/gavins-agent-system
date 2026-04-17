# Agent System — Active Backlog

Forward-looking work for the agent system. **Completed items live in [STATUS.md](./STATUS.md) and `git log` — not here.** The previous long-form history of items 1–29 has been retired; see commit history or STATUS.md tables for what shipped when.

For day-to-day suggestions (new skills, agent gaps, workflow pain points), drop short markdown files in `improvements/{skills,agents,system}/`. This file is for durable, larger backlog items.

---

## Deferred (proven-need gate)

These were considered and intentionally not built yet. Each has a revisit trigger — don't build until it fires.

### Cross-agent memory

- **Status:** Deferred by design.
- **Idea:** Shared `project-memory/` space so agents working on the same project don't re-derive context the previous agent already learned.
- **Revisit trigger:** When a multi-agent run visibly drops context between specialists on the same codebase — e.g., `frontend-engineer` re-deriving the API shape the `backend-engineer` just defined.
- **Cheaper alternative to try first:** Orchestrator (main conversation) summarizes outputs between agents before handoff.

### Agent SDK adoption

- **Status:** Deferred.
- **Idea:** Replace the instruction-following dispatch layer (skill-router + CLAUDE.md table) with programmatic routing via the Claude Agent SDK. Deterministic "if task touches IAM then threat-modeler runs."
- **Revisit trigger:** Tier 3 or Tier 4 evals show dispatch failures (wrong agent picked, mandatory step skipped) under current instruction-following.
- **Also revisit if:** Agents need to run outside Claude Code (CI, web service, scheduled task).
- **Current signal:** 28/28 on review challenges, 4/4 Tier 1, all Tier 2–4 passing. Routing is working.

### CLAUDE.md splitting

- **Status:** Deferred — the rules/ directory absorbed most domain-specific content already.
- **Idea:** Break CLAUDE.md into `SYSTEM.md`, `CODE_STANDARDS.md`, `SECURITY.md`.
- **Revisit trigger:** CLAUDE.md approaches 200 lines again after further additions. Currently ~115.

---

## Future (when projects demand it)

Coverage gaps that are worth filling, but only once a real project needs them. Don't build speculatively.

| Gap | Build when |
|---|---|
| React Native patterns | First mobile project starts |
| Desktop app patterns (Electron/Tauri) | First desktop project starts |
| Azure cloud references | First Azure engagement |
| Monorepo patterns (pnpm workspaces / Turborepo) | First workspace-structured repo |

---

## Active Opportunities

Items identified but not yet built or scheduled. Triage these into concrete tickets when picking up.

### Hook coverage gaps

- `lint-on-save` and `doc-drift-check` were recently wired into settings.json. Confirm they fire during real sessions (not just the install merge) and that linter output reaches Claude.
- Consider a `PreToolUse Bash(git commit *)` hook that greps staged files for `console.log`, `print()`, `debugger` (from the retired Error Handling section #24) — not currently implemented.

### Eval freshness

- All eval runs in STATUS.md are dated 2026-04-03 / 2026-04-04. A lot has shipped since (rules, hooks, frontmatter modernization). Re-run Tier 2 and Tier 4 against the current system to confirm nothing regressed.

### `improvements/` backlog activation

- `improvements/skills/` and `improvements/agents/` are empty; only `improvements/system/add-eval-automation.md` lives there. The self-improvement loop is structurally enabled but underused in practice. After each real multi-agent run, log at least one friction point.

---

## Process notes

- **Every entry above must have a revisit trigger or a "build when."** Entries without one drift into speculative future-proofing — delete them instead.
- **When an item ships,** remove it from this file. Do not leave a strikethrough or "(done)" marker. The audit trail lives in git and STATUS.md.
- **Target:** keep this file under 150 lines. If it grows, something is being deferred that shouldn't be.
