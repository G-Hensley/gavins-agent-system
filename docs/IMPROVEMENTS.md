# Agent System — Improvement Plan

Consolidated feedback from system reviews. Work through these with Claude Code to iterate toward a self-improving, fully-tested agent system.

---

## 1. Eval Suite — Test Every Agent

The system has 23 agents but zero tests. Build an `evals/` directory that exercises every agent through graded prompts and seeded review challenges.

### Structure

```
evals/
├── README.md                    # How to run evals, what to check
├── tier-1-single-agent/         # Simple tasks, one agent each
├── tier-2-multi-agent/          # Tasks requiring agent handoffs
├── tier-3-architecture-first/   # Complex enough for full pipeline
├── tier-4-full-workflow/        # End-to-end subagent-driven-development
├── review-challenges/           # Pre-built code with planted issues
│   ├── sql-injection/           # backend-security-reviewer target
│   ├── overpermissive-iam/      # cloud-security-reviewer target
│   ├── xss-vulnerability/       # frontend-security-reviewer target
│   ├── dependency-vuln/         # appsec-reviewer target
│   ├── spec-deviation/          # spec-reviewer target
│   └── code-quality-issues/     # code-quality-reviewer target
└── agent-coverage.md            # Matrix showing which test hits which agent
```

### Agent Coverage Matrix

Every agent must be exercised by at least one eval. The matrix below maps agents to test tiers.

| Agent | Tier 1 | Tier 2 | Tier 3 | Tier 4 | Review Challenge |
|---|---|---|---|---|---|
| **ai-engineer** | ChatBot CLI with LLM API | — | RAG system | Full-stack AI app | — |
| **automation-engineer** | CLI calculator | File watcher script | — | — | — |
| **backend-engineer** | REST endpoint | — | Game server API | Full-stack app | — |
| **database-engineer** | Schema + migrations | — | Multi-table design | Full-stack app | — |
| **devops-engineer** | Dockerfile | CI pipeline | — | Full-stack app | — |
| **devsecops-engineer** | — | Secrets scanning setup | Security pipeline | — | — |
| **doc-writer** | README for calculator | API docs | Architecture docs | Full-stack app | — |
| **frontend-engineer** | — | Tic-tac-toe UI | Three.js scene | Full-stack app | — |
| **implementer** | — | — | — | Full-stack app (per-task) | — |
| **qa-engineer** | Unit test suite | E2E test plan | Load test strategy | Full-stack app | — |
| **architect** | — | — | Game architecture | Full-stack app | — |
| **product-manager** | — | — | Game PRD | Full-stack app | — |
| **uiux-designer** | — | Tic-tac-toe design system | — | Full-stack app | — |
| **appsec-reviewer** | — | — | — | — | dependency-vuln |
| **architecture-reviewer** | — | — | Review game design doc | — | — |
| **backend-security-reviewer** | — | — | — | — | sql-injection |
| **cloud-security-reviewer** | — | — | — | — | overpermissive-iam |
| **code-explorer** | — | Explore tic-tac-toe codebase | Explore game codebase | — | — |
| **code-quality-reviewer** | — | — | — | — | code-quality-issues |
| **frontend-security-reviewer** | — | — | — | — | xss-vulnerability |
| **plan-reviewer** | — | — | Review game impl plan | — | — |
| **product-reviewer** | — | — | Review game PRD | — | — |
| **spec-reviewer** | — | — | — | — | spec-deviation |

### Tier 1 — Single Agent, Simple Task

Each prompt tests one agent in isolation. Eval criteria: correct agent dispatched, TDD followed, output works.

- **CLI Calculator** (Python) → `automation-engineer`, `qa-engineer`, `doc-writer`
- **REST Endpoint** (single CRUD resource) → `backend-engineer`, `database-engineer`
- **Dockerfile** for a Python app → `devops-engineer`
- **ChatBot CLI** with Claude API → `ai-engineer`

### Tier 2 — Multi-Agent Handoff

Tasks require coordination between 2-3 agents. Eval criteria: correct dispatch sequence, artifacts passed between agents, design before implementation.

- **Tic-Tac-Toe** (terminal + web UI) → `uiux-designer` → `frontend-engineer`, `code-explorer`
- **File Watcher Script** with CI integration → `automation-engineer` → `devops-engineer`
- **Secrets Scanning Pipeline** → `devsecops-engineer` → `devops-engineer`

### Tier 3 — Architecture-First

Complex enough that `architect` must produce a design doc before implementation. Eval criteria: architecture doc produced, reviewed by `architecture-reviewer`, plan reviewed by `plan-reviewer`, TDD throughout.

- **Snake/Pong Game** → `product-manager` → `architect` → `backend-engineer` + `frontend-engineer` + `qa-engineer`
- **Three.js Interactive Scene** → `uiux-designer` → `architect` → `frontend-engineer`
- **RAG System** → `architect` → `ai-engineer` + `database-engineer`

### Tier 4 — Full Workflow (Subagent-Driven Development)

End-to-end: brainstorm → product-manager → architect → writing-plans → implementer agents → spec-reviewer → code-quality-reviewer → security reviewers → doc-writer.

- **Full-Stack Task Manager App** (Next.js + API + DynamoDB + auth) — exercises nearly every agent in the system

### Review Challenges — Seeded Defects

Pre-built mini-projects with known issues. Each targets a specific reviewer agent. Score: did the reviewer find the planted defect?

- **sql-injection/**: Express endpoint with string-concatenated SQL → `backend-security-reviewer`
- **overpermissive-iam/**: CloudFormation template with `Resource: "*"` and `Action: "*"` → `cloud-security-reviewer`
- **xss-vulnerability/**: React component with `dangerouslySetInnerHTML` from user input → `frontend-security-reviewer`
- **dependency-vuln/**: package.json with known vulnerable dependency versions → `appsec-reviewer`
- **spec-deviation/**: Implementation that's missing 2 requirements from the spec → `spec-reviewer`
- **code-quality-issues/**: Working code with duplicated logic, missing error handling, magic numbers → `code-quality-reviewer`

### Eval Criteria Per Test

Each eval prompt should include a checklist:

1. **Dispatch correctness** — Was the right agent(s) dispatched?
2. **Workflow compliance** — Did TDD happen? Was architecture produced before implementation?
3. **Output quality** — Does the code work? Are tests passing?
4. **Agent-specific rules** — Did the agent follow its own SKILL.md/agent definition?
5. **Handoff quality** — Were artifacts properly passed between agents?
6. **Review thoroughness** — Did reviewers catch what they should have caught?

---

## 2. System Validation (CI/Linting)

Add automated checks that prevent the system from silently breaking.

### install.sh Improvements

- Add `--dry-run` flag that shows what would be symlinked without doing it
- Add `--verify` flag that checks all symlinks are intact and targets exist
- Test in a clean container to catch assumptions about existing state

### Validation Script (`validate.sh`)

Create a script that checks:

- [ ] Every agent referenced in CLAUDE.md dispatch table exists in `agents/`
- [ ] Every skill referenced in `skill-router/SKILL.md` exists in `skills/`
- [ ] All SKILL.md files are under 200 lines
- [ ] All agent .md files are under 200 lines
- [ ] All reference files are under 200 lines
- [ ] All agent .md files have required frontmatter (name, description, tools, model)
- [ ] All SKILL.md files have valid structure
- [ ] No dead cross-references (agent references a skill that doesn't exist)
- [ ] `plugins/plugins.json` is valid JSON

---

## 3. Agent Memory Gap

Only `code-explorer` (12 files) and `architecture-reviewer` (3 files) have accumulated learnings. `backend-engineer` and `frontend-engineer` have empty memory directories. The remaining 19 agents don't even have memory directories yet.

### Actions

- [ ] Create `agent-memory/<name>/` directories for all 23 agents
- [ ] After each real project, review what the agent learned and seed its memory
- [ ] Consider a post-session hook that prompts: "What did this agent learn that's worth remembering?"

---

## 4. Improvements Backlog Bootstrap

The `improvements/skills/` and `improvements/agents/` directories are empty. The self-improvement feedback loop exists structurally but hasn't been activated.

### Actions

- [ ] After each eval run, log at least one improvement suggestion per agent that underperformed
- [ ] Review improvements weekly and promote the best ones to actual skill/agent changes
- [ ] Consider adding `improvements/system/` for cross-cutting improvements (workflow, config, tooling)

---

## 5. Architecture & Config Separation + CONTEXT.md

CLAUDE.md is doing double duty — personal preferences AND system operating manual. As the system grows, this will get unwieldy.

### Proposed Split

```
CLAUDE.md              → Personal preferences, response style, stack choices
SYSTEM.md              → Agent dispatch table, skill routing rules, workflow definitions
CODE_STANDARDS.md      → File size limits, naming conventions, commit format
SECURITY.md            → Security principles, reviewer dispatch rules
```

Evaluate whether this split actually helps or just adds indirection. The current single-file approach works fine at 97 lines — revisit when it approaches 200.

### CONTEXT.md — Supplementary Project Context

Add a `CONTEXT.md` file that provides ambient context Claude Code loads alongside CLAUDE.md. Where CLAUDE.md is rules and preferences, CONTEXT.md is situational awareness — the kind of context a new team member would need on day one.

Potential contents:

- **Project landscape**: What repos exist, what they do, how they relate to each other
- **Current state**: What's actively being worked on, what's stable, what's in flux
- **Domain terminology**: APIsec-specific terms, internal naming conventions, acronyms
- **Infrastructure map**: Which AWS accounts, what's deployed where, environment topology
- **Key decisions**: Why certain tech choices were made (e.g., why DynamoDB over Postgres, why Cognito SRP)
- **Team context**: Who works on what, who to check with for certain domains (useful when agents need to know who the human authority is for a decision)

This could also be the right place for the agent parallelism rules (see #13) since that's operational context about how the system works, not a preference or code standard.

CONTEXT.md should be loaded by agents that need project awareness (architect, product-manager, code-explorer) but can be skipped by narrow specialists (doc-writer, implementer) to keep their context windows lean.

---

## 6. Plans Directory Hygiene

The `plans/` directory accumulates session-specific plans that are ephemeral. Two options:

- **Option A**: Curate the best plans as templates in `plans/templates/` and gitignore the rest
- **Option B**: Gitignore `plans/` entirely and treat plans as conversation artifacts

Either way, old session plans shouldn't accumulate in version control.

---

## 7. Skill Composition & Dependencies

Skills are currently flat — the skill-router dispatches to one skill at a time. Real work often needs skill chains: `architecture` → `writing-plans` → `test-driven-development` → `backend-engineering` → `code-review`.

### Actions

- [ ] Document common skill chains as "workflows" (the `/plan` command does this implicitly — make it explicit)
- [ ] Consider adding a `depends_on` or `follows` field to SKILL.md frontmatter
- [ ] The skill-router could suggest chains, not just individual skills

---

## 8. Agent Handoff Protocol

When `architect` produces a design doc and `implementer` picks it up, the contract is implicit. Formalizing this would reduce dropped context.

### Actions

- [ ] Define standard output locations per agent (e.g., architect → `docs/architecture/`, product-manager → `docs/prd/`)
- [ ] Define what the receiving agent should expect as input
- [ ] Document handoff contracts in each agent's .md file

---

## 9. Failure Mode Documentation

No guidance exists for when things go wrong in multi-agent workflows.

### Scenarios to Document

- [ ] Implementer reports BLOCKED — what's the escalation path?
- [ ] Spec-reviewer rejects 3+ times — when to escalate vs. iterate?
- [ ] Architect's design conflicts with existing codebase — who decides?
- [ ] Security reviewer finds critical issue mid-implementation — halt or continue?
- [ ] Agent dispatched for a task outside its competency — how to reroute?

---

## 10. Skill Staleness Detection

Reference files can drift from reality over time. SDK patterns change, best practices evolve.

### Actions

- [ ] Add `last_verified: YYYY-MM-DD` to SKILL.md frontmatter
- [ ] Flag anything older than 90 days for review
- [ ] Could be automated with a scheduled task or a `validate.sh` check

---

## 11. Cross-Agent Memory

Agent memory is per-agent, but agents working on the same project don't share context. The `backend-engineer` might learn something about the API design that `frontend-engineer` needs.

### Actions

- [ ] Consider a shared `project-memory/` space for per-project learnings
- [ ] Alternatively, the orchestrator (main conversation) could summarize and pass context between agents
- [ ] Start lightweight — see if this is actually a problem in practice before building infrastructure

---

## 12. Agent Parallelism Map

There's no documentation of which agents can safely run in parallel and which must be sequential. This matters for both performance (don't serialize work that could overlap) and correctness (don't run two agents that write to the same files simultaneously).

### Sequential Dependencies (Must Wait)

These have hard ordering constraints — the downstream agent needs the upstream agent's output:

```
product-manager → architect → writing-plans → implementer(s)
uiux-designer → frontend-engineer
architect → backend-engineer / frontend-engineer / database-engineer
implementer → spec-reviewer → code-quality-reviewer
```

### Safe to Parallelize

These agents work on independent concerns and don't write to overlapping files:

```
# Multiple code-explorers (different aspects of the same codebase)
code-explorer (architecture) ‖ code-explorer (data flow) ‖ code-explorer (similar features)

# Independent domain implementation (after architecture is done)
backend-engineer ‖ frontend-engineer ‖ database-engineer

# Independent reviewers (after implementation is done)
backend-security-reviewer ‖ frontend-security-reviewer ‖ cloud-security-reviewer ‖ appsec-reviewer

# Review + documentation (documentation can start from the design doc)
spec-reviewer ‖ doc-writer

# Multiple implementers on different tasks (subagent-driven-development already does this)
implementer (task-1) ‖ implementer (task-2) ‖ implementer (task-3)
```

### Never Parallelize

These will conflict or produce inconsistent results:

```
# Two agents writing to the same files
backend-engineer ‖ database-engineer (if both touch the data layer)
frontend-engineer ‖ uiux-designer (designer must finish first)

# Review before the thing being reviewed exists
architecture-reviewer before architect finishes
plan-reviewer before writing-plans finishes
product-reviewer before product-manager finishes
spec-reviewer before implementer finishes
```

### Actions

- [ ] Document parallelism rules in CONTEXT.md or SYSTEM.md (wherever the config split lands)
- [ ] Add parallelism hints to each agent's .md frontmatter (e.g., `parallel_safe_with: [doc-writer, qa-engineer]`)
- [ ] The subagent-driven-development skill should reference these rules when dispatching

---

## 13. Metric Collection & Token Tracking

If running evals, track data to measure improvement over time. Token usage is especially important — it's both a cost signal and a quality signal (an agent burning 50k tokens on a simple task is a red flag).

### What to Log Per Eval Run

- Date and system version (git SHA)
- Which agents were dispatched
- Whether TDD was followed (yes/no)
- Number of review cycles before acceptance
- Defects caught (for review challenges)
- Wall-clock time (rough)
- Any unexpected behaviors or failures

### Token Tracking (Per Agent, Every Run)

Track token usage at the agent level, not just the session level. This gives you:

- **Cost visibility**: Which agents are expensive? Is `architect` (Opus) worth 10x the tokens of `implementer` (Sonnet)?
- **Efficiency signal**: If `backend-engineer` uses 30k tokens for a simple endpoint, the skill or prompt may need tightening
- **Regression detection**: If an agent's token usage spikes between system versions, something changed
- **Model selection validation**: Are Opus agents actually producing better output than Sonnet, or just burning more tokens?

What to capture per agent dispatch:

```json
{
  "agent": "backend-engineer",
  "model": "opus",
  "task": "REST endpoint for /api/users",
  "tokens": {
    "input": 12450,
    "output": 8320,
    "total": 20770
  },
  "duration_seconds": 45,
  "status": "DONE",
  "review_cycles": 1
}
```

### Token Budgets (Future)

Once you have baseline data, set per-agent token budgets:

- Tier 1 tasks: expect < 20k tokens per agent
- Tier 2 tasks: expect < 50k tokens per agent
- Tier 3 tasks: expect < 100k tokens per agent
- Tier 4 tasks: track total across all agents, flag if > 500k

Flag agents that consistently exceed budget — either the task is underscoped or the agent needs optimization.

### Storage

Store as JSON in `evals/results/YYYY-MM-DD/`. One file per eval run with nested agent metrics. Aggregate trends over time to spot regressions.

---

## 14. Threat Modeler Agent & Design-Time Security Gap

The `threat-modeling` skill exists (VAST methodology, STRIDE categories, dispatches to security reviewers) and the skill-router knows about it, but **no agent loads or executes it**. It's the only skill in the router without a natural agent pairing.

### The Gap

The current security coverage is strong at code-time (4 security reviewers) and build-time (devsecops-engineer), but weak at design-time. The `architect` agent doesn't load the `security` or `threat-modeling` skills, so architecture decisions get made without security input. Security review only happens post-implementation — by then, architectural flaws are expensive to fix.

```
Current:  architect → implementers → security reviewers (too late for architectural issues)
Proposed: architect → threat-modeler → implementers → security reviewers
```

### Proposed: `threat-modeler` Agent

An orchestrator agent (Opus) that owns the full VAST lifecycle:

1. Takes the architect's design doc as input
2. Maps system boundaries, data flows, and trust boundaries
3. Identifies threats using STRIDE at each trust boundary crossing
4. Proposes specific mitigations with severity scores
5. Dispatches domain-specific security reviewers to validate mitigations
6. Produces a threat model document that lives alongside the architecture doc

Skills: `threat-modeling`, `security`
Model: Opus (needs architectural reasoning)
Fits in the pipeline between `architect` and `implementer`

### Also Consider

- **Load `security` skill on the `architect` agent** — even without a threat-modeler, the architect should at least be security-aware when making design decisions. Right now it isn't.
- **Add threat-modeler to the dispatch table** — "Security assessment needed before implementation" → `threat-modeler` agent
- **Add to eval suite** — Tier 3 projects should include a threat modeling step; review challenges could include an architecture doc with obvious security gaps (public S3 + no auth on admin endpoints) to test whether the agent catches design-level flaws

### Parallelism Note

The threat-modeler is sequential with the architect (needs the design doc) but can run in parallel with the plan-reviewer and architecture-reviewer since they're reviewing different aspects of the same design.

---

## 15. Adopt `.claude/rules/` with Path-Scoped Globs

Claude Code supports a `.claude/rules/` directory where each `.md` file can have YAML frontmatter with `paths:` glob patterns. Rules only load when Claude works with matching files — this is more context-efficient than loading everything from CLAUDE.md every session.

### What to Move

Move domain-specific instructions out of CLAUDE.md and into scoped rules:

```
.claude/rules/
├── security.md          # paths: ["**/auth/**", "**/iam/**", "**/*security*"]
├── frontend.md          # paths: ["src/components/**", "**/*.tsx", "**/*.jsx"]
├── backend-python.md    # paths: ["**/*.py", "**/services/**", "**/handlers/**"]
├── backend-node.md      # paths: ["**/api/**/*.ts", "**/routes/**"]
├── aws-infra.md         # paths: ["**/*.yaml", "**/cdk/**", "**/cloudformation/**"]
├── testing.md           # paths: ["**/*test*", "**/*spec*", "**/fixtures/**"]
└── database.md          # paths: ["**/migrations/**", "**/models/**", "**/schema*"]
```

### Why This Matters

- CLAUDE.md stays under 200 lines with only universal rules
- Domain rules only consume context when relevant (working on Python files doesn't load React rules)
- Rules are git-committable and shareable per-project
- Works alongside the existing skill system — rules are static instructions, skills are dynamic workflows

### Actions

- [ ] Identify which CLAUDE.md sections are domain-specific vs. universal
- [ ] Create `.claude/rules/` directory with path-scoped files
- [ ] Keep CLAUDE.md for: response style, commit format, YAGNI/DRY/TDD principles, agent dispatch table
- [ ] Add rule validation to `validate.sh` (check paths are valid globs, no duplicates)

---

## 16. Dynamic Context in Skills via `!`command`` Syntax

Skills support `!`command`` syntax in their body that executes shell commands before the content reaches Claude. This enables dynamic context injection — the skill can pull in live state rather than relying on static instructions.

### Opportunities

- **skill-router**: Inject `!`git branch --show-current`` and `!`git diff --stat`` so routing decisions account for current work state
- **git-workflow**: Inject `!`git status --short`` and `!`git log --oneline -5`` so the skill sees the current repo state
- **code-review**: Inject `!`git diff HEAD~1`` to automatically load the diff being reviewed
- **systematic-debugging**: Inject `!`git log --oneline -3`` to see recent changes that might have introduced the bug

### Actions

- [ ] Audit all skills for opportunities to use dynamic context
- [ ] Start with git-workflow and code-review as highest-impact candidates
- [ ] Test that `!`command`` works in subagent skill loading (not just main conversation)

---

## 17. Hooks for Structural Enforcement

The system relies entirely on Claude following instructions (CLAUDE.md, skills). Hooks make enforcement structural — they execute automatically at lifecycle events and can block, modify, or augment tool calls.

### High-Value Hooks to Build

**TDD Enforcement** (`PreToolUse` on `Write`):
- When a new source file is created, check whether a corresponding test file exists
- If not, inject context: "No test file found for this source file. TDD requires writing tests first."

**Pre-Commit Validation** (`PreToolUse` on `Bash(git commit *)`):
- Run `scripts/validate.sh` before allowing commits
- Block if validation fails

**Session Start Context** (`SessionStart`):
- Load CONTEXT.md automatically
- Run `git status` and inject current branch/state

**Post-Edit Lint** (`PostToolUse` on `Edit`/`Write`):
- Run linter on modified files
- Feed results back to Claude

**Destructive Command Guard** (`PreToolUse` on `Bash`):
- Block `rm -rf`, `git push --force`, `DROP TABLE` etc.
- Require explicit confirmation

### Actions

- [ ] Create `.claude/hooks/` directory
- [ ] Start with TDD enforcement and pre-commit validation (highest impact)
- [ ] Add hook definitions to `settings.json` or `settings.local.json`
- [ ] Add hooks to the eval criteria — do hooks fire correctly during eval runs?
- [ ] Document hooks in CONTEXT.md

---

## 18. Skill Frontmatter Modernization

Several skill frontmatter fields are available but not used in the current system. Adopting them would improve isolation, auto-activation, and tool scoping.

### Fields to Adopt

- **`context: fork`** — Run skills in subagent isolation. Critical for review skills (code-quality-reviewer, spec-reviewer, security reviewers) where isolated context prevents contamination from the main conversation.
- **`paths:`** — Auto-activate skills when Claude works with matching files. `backend-engineering` could activate on `**/*.py` and `**/services/**` without manual routing.
- **`allowed-tools:`** — Restrict which tools a skill can use. Review skills should only have `Read, Grep, Glob` — they shouldn't be able to `Write` or `Edit`.
- **`agent:`** — Specify which subagent type to use (e.g., `Explore` for code-explorer).
- **`model:`** — Per-skill model override. Some skills may work fine on Sonnet, saving Opus tokens.

### Actions

- [ ] Audit all 27 skills for applicable frontmatter additions
- [ ] Prioritize: `context: fork` on review skills, `paths:` on domain skills, `allowed-tools:` on read-only skills
- [ ] Test that frontmatter changes don't break existing agent dispatch
- [ ] Add frontmatter validation to `validate.sh`

---

## 19. Agent SDK — When to Adopt

The Claude Agent SDK enables programmatic orchestration outside of Claude Code's instruction-following model. **Not needed yet**, but worth knowing when it becomes the right tool.

### When to Consider

- When instruction-following isn't reliable enough for critical routing (e.g., Claude skips threat-modeler despite the dispatch table saying to use it)
- When you want deterministic pipelines: "if task touches IAM, always run threat-modeler" as code, not as a prompt instruction
- When building a standalone tool that orchestrates agents externally (not within Claude Code)
- When you need custom error handling, retry logic, or conditional branching that's too complex for hooks

### What It Would Replace

The Agent SDK would replace the *dispatch layer* — the skill-router and CLAUDE.md dispatch table — with programmatic routing. The skills, agent definitions, and memory system would stay the same.

### Current Recommendation

Stay file-based. The skill-router + dispatch table + hooks stack covers the current use case well. The eval results (28/28 on reviews, 4/4 on Tier 1) show that instruction-following is working. Revisit if:
- Tier 3/4 evals show dispatch failures
- You need to run agents outside of Claude Code (CI pipeline, web service, etc.)
- You want guaranteed routing that doesn't depend on Claude reading instructions correctly

---

## 20. Dependency Management Skill

No skill codifies *how* to evaluate, add, or manage dependencies. The appsec-reviewer checks for vulnerabilities after the fact, but nobody guides the decision to add a dependency in the first place.

### Shared Reference: `references/dependency-management.md`

Add to `backend-engineering`, `frontend-engineering`, and `automation-engineering` skills. Contents:

- **Add vs. build decision**: If it's < 50 lines, has no transitive deps, and you understand the domain — write it yourself. If it's a solved, complex problem (crypto, date handling, compression) — use a library.
- **Evaluation checklist**: Maintenance activity (last commit < 6 months), download count, open issues/PR ratio, number of contributors (avoid single-maintainer for critical deps), license compatibility (MIT/Apache preferred), bundle size (for frontend), transitive dependency count.
- **Version strategy**: Pin exact versions for production deps. Use ranges only for devDependencies. Update intentionally — security patches immediately, minor versions weekly, major versions as planned work.
- **Lock file discipline**: Always commit `pnpm-lock.yaml` / `uv.lock`. Use `--frozen-lockfile` in CI. Review lock file diffs in PRs for unexpected transitive changes.
- **Audit cadence**: Run `pnpm audit` / `uv pip audit` before every PR merge. Block on critical/high. Document exceptions with linked issues.
- **Removal hygiene**: When removing a dep, verify no transitive consumers remain. Remove from lock file. Check bundle size delta.

### Actions

- [ ] Create `references/dependency-management.md` as a shared reference
- [ ] Add to `backend-engineering`, `frontend-engineering`, and `automation-engineering` skill reference lists
- [ ] Add dependency evaluation to the `appsec-reviewer` agent's pre-review checklist

---

## 21. TypeScript Strictness Rules

"No `any`" is a start but barely scratches the surface. These rules should load automatically on every `.ts` / `.tsx` file via path-scoped rules.

### `.claude/rules/typescript.md`

```yaml
---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---
```

Rules to include:

- `strict: true` in tsconfig — non-negotiable. Not just `strictNullChecks`, the full suite.
- No `any`. Use `unknown` for external data boundaries, then narrow with Zod or type guards.
- No `as` type assertions without a comment explaining why. Prefer `satisfies` for type narrowing.
- No `@ts-ignore` or `@ts-expect-error` without a linked issue number.
- Branded types for IDs: `type UserId = string & { __brand: 'UserId' }` — prevents passing `teamId` where `userId` is expected.
- Prefer `interface` for object shapes, `type` for unions/intersections/utilities.
- Exhaustive switch statements with `never` default for discriminated unions.
- No implicit return types on exported functions — always annotate.
- Zod schemas as the source of truth for runtime validation; infer TypeScript types from them (`z.infer<typeof Schema>`).

---

## 22. Python Project Structure Rules

### `.claude/rules/python.md`

```yaml
---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---
```

Rules to include:

- Always `pyproject.toml` — never `setup.py`, `setup.cfg`, or `requirements.txt`.
- `src/` layout: `src/<package_name>/` with `__init__.py`. Tests in `tests/` at project root.
- `uv` for everything: `uv init`, `uv add`, `uv run`, `uv sync`. Never raw `pip`.
- Type hints on every function signature. Use `from __future__ import annotations` for modern syntax.
- `py.typed` marker file in packages intended for external consumption.
- `ruff` for linting AND formatting (replaces flake8, black, isort, pyflakes). Single tool, one config section in `pyproject.toml`.
- Dataclasses or Pydantic for data structures — never raw dicts for structured data.
- `asyncio` patterns: prefer `async/await` over threading. Use `asyncio.gather()` for parallel I/O.
- No `print()` in production code — use `logging` module with structured output. `print()` is acceptable only in CLI entry points.
- Minimum Python version: 3.11+ (for `tomllib`, exception groups, `StrEnum`).

---

## 23. Project Structure References (Per Framework)

Each framework has idiomatic project layouts. Claude defaults to generic structures without this guidance.

### References to Create

**`frontend-engineering/references/nextjs-patterns.md`**:
- App Router directory structure (`app/`, `components/`, `lib/`, `hooks/`)
- When to use `use client` (only at the leaf, never on pages)
- Server Actions vs. API routes (prefer actions for mutations, routes for external consumers)
- Loading/error boundary patterns per route segment
- `generateStaticParams` vs. dynamic rendering decisions
- Metadata API for SEO
- `revalidatePath` / `revalidateTag` caching strategy

**`frontend-engineering/references/react-patterns.md`**:
- Component structure: feature-based folders, not type-based
- Custom hooks for shared logic, not utility files
- Composition over prop drilling — use context sparingly, prefer passing components as props
- Suspense boundaries and error boundaries at route level

**`backend-engineering/references/api-frameworks.md`**:
- FastAPI (Python): routers, dependency injection, Pydantic models, middleware
- Express/Hono (TypeScript): route handlers, middleware chains, Zod validation
- Spring Boot (Java): controllers, services, repositories, dependency injection

**`ai-engineering/references/project-structure.md`**:
- Agent projects: prompts/, tools/, agents/, evaluation/, config/
- RAG projects: ingestion/, retrieval/, generation/, evaluation/
- Prompt versioning and testing patterns

### Future (When Needed)

- **React Native**: When building mobile apps — project structure, navigation patterns, platform-specific code organization, Expo vs. bare workflow
- **Desktop (Electron/Tauri)**: When building desktop apps — main/renderer process separation, IPC patterns, native module integration, auto-update
- **Monorepo (pnpm workspaces/Turborepo)**: Workspace layout, shared packages, incremental builds, CI that only tests what changed

### Actions

- [ ] Create Next.js and React pattern references under `frontend-engineering/references/`
- [ ] Create API frameworks reference under `backend-engineering/references/`
- [ ] Create AI project structure reference under `ai-engineering/references/`
- [ ] Log React Native and desktop app references as future items when those projects start

---

## 24. Error Handling Patterns

No explicit error handling guidance exists. Claude tends to either swallow errors or throw generic ones.

### Reference: `backend-engineering/references/error-handling.md`

- **Never catch and ignore.** Every catch block must log, re-throw, or handle with a specific recovery.
- **Typed error classes per domain**: `NotFoundError`, `ValidationError`, `AuthorizationError`, `ConflictError` — not generic `Error` or string messages.
- **Errors carry context**: What failed, why, what was attempted, correlation ID for tracing.
- **Distinguish operational vs. programmer errors**: Operational (network timeout, invalid input) → handle gracefully, maybe retry. Programmer (null reference, type error) → crash fast, fix the bug.
- **HTTP status code mapping**: `ValidationError` → 400, `AuthorizationError` → 403, `NotFoundError` → 404, `ConflictError` → 409, unhandled → 500. Never return 200 with an error body.
- **Error responses are structured**: `{ error: { code: string, message: string, details?: unknown } }` — never raw strings.
- **Logging levels matter**: ERROR for failures requiring attention, WARN for degraded but functional, INFO for normal operations, DEBUG for development only.

### Reference: `frontend-engineering/references/error-handling.md`

- Error boundaries at route level, not component level
- Toast/notification for user-facing errors, never raw error messages
- Retry with backoff for network failures
- Distinguish between "try again" errors and "contact support" errors

### Production Hygiene Rules

Add to `.claude/rules/` or as a hook:

- **No `console.log()` in production code** — use structured logging. `console.log` is for debugging only, remove before merging.
- **No `print()` in production Python** — use `logging` module.
- **No `debugger` statements** — ever.
- **No `TODO` or `FIXME` without an issue link** — either fix it now or track it properly.

### Actions

- [ ] Create error handling references for both backend and frontend engineering skills
- [ ] Add production hygiene rules as a `.claude/rules/production.md` with path scope
- [ ] Consider a `PreToolUse` hook on `Bash(git commit *)` that greps for `console.log` / `print()` / `debugger` in staged files

---

## 25. Database References Expansion

The current `database-engineering` skill is generic. Each database has its own patterns.

### References to Create

**`database-engineering/references/dynamodb-patterns.md`** (high priority — primary DB):
- Single-table vs. multi-table design decisions
- Access pattern analysis BEFORE schema design — list all queries first
- Partition key and sort key design for even distribution
- GSI design: overloaded keys, sparse indexes, projection optimization
- Write sharding for hot partitions
- TTL for data lifecycle management
- Transaction patterns and limitations (25-item limit, idempotency tokens)
- DynamoDB Streams for event-driven patterns
- Cost optimization: on-demand vs. provisioned, reserved capacity

**`database-engineering/references/mongodb-patterns.md`**:
- Document model design — embed vs. reference decision tree
- Schema validation with JSON Schema
- Indexing strategy: compound indexes, covered queries, index intersection
- Aggregation pipeline patterns
- Change streams for real-time
- Sharding considerations

**`database-engineering/references/postgresql-patterns.md`** (for when SQL is needed):
- Schema design, normalization decisions
- Index types: B-tree, GIN, GiST, BRIN — when to use each
- Query optimization: EXPLAIN ANALYZE, common anti-patterns
- Migration safety: backward-compatible changes, zero-downtime patterns
- Connection pooling (PgBouncer)
- JSONB for semi-structured data within relational context

### Actions

- [ ] Create DynamoDB patterns reference (highest priority)
- [ ] Create MongoDB patterns reference
- [ ] Create PostgreSQL patterns reference
- [ ] Update `database-engineer` agent to reference database-specific patterns based on the project's DB

---

## 26. Cloud Provider Expansion (Google Cloud)

The system is AWS-only. Adding Google Cloud references enables working on GCP projects.

### References to Create

**`devops/references/gcp-infrastructure.md`**:
- Cloud Run, Cloud Functions, GKE — equivalent mapping to AWS Lambda/ECS
- Cloud SQL, Firestore, BigQuery — database options
- IAM: service accounts, workload identity, least-privilege
- Secret Manager, Cloud KMS
- Cloud Build for CI/CD
- Terraform patterns for GCP (most teams use Terraform over Deployment Manager)

**`security/references/gcp-security.md`**:
- Service account key management (prefer workload identity federation)
- VPC Service Controls
- Organization policies
- Security Command Center
- IAM Conditions and context-aware access

### Actions

- [ ] Create GCP infrastructure reference under `devops/references/`
- [ ] Create GCP security reference under `security/references/`
- [ ] Update `cloud-security-reviewer` agent to handle GCP patterns alongside AWS
- [ ] Consider adding Azure references as a future item if needed

---

## 27. API Versioning, App Versioning & Auto-Documentation

### API Versioning Reference: `api-design/references/versioning.md`

- URL path versioning (`/v1/users`) for public APIs — most explicit, easiest for consumers
- Header versioning (`Accept: application/vnd.api+json;version=1`) for internal APIs
- Backward compatibility rules: additive changes only in minor versions (new fields OK, removing/renaming fields is a breaking change)
- Deprecation lifecycle: announce → warn (header) → sunset date → remove
- Contract testing between frontend and backend (Pact, or Zod schemas shared via package)

### App/Release Versioning Reference

- Semantic versioning: MAJOR.MINOR.PATCH — follow it strictly
- Git tags for releases (`v1.2.3`)
- Automated version bumping in CI (conventional commits → auto-version)
- GitHub Releases with auto-generated changelogs (`gh release create`)
- Package version in `package.json` / `pyproject.toml` matches git tag
- Pre-release versions: `1.2.3-rc.1` for release candidates

### Auto-Documentation Skill/Reference

Generate API documentation from code rather than maintaining it separately:

- **OpenAPI/Swagger generation**:
  - FastAPI: built-in OAS generation from Pydantic models — just configure metadata
  - Express/Hono: `zod-openapi` or `tsoa` to generate OAS from Zod schemas
  - Spring Boot: `springdoc-openapi` for auto-generation from annotations
- **Keep spec and code in sync**: OAS spec is generated from code, never hand-edited. CI check that spec matches implementation.
- **Documentation hosting**: Redoc or Swagger UI auto-deployed from generated spec
- **Client SDK generation**: `openapi-typescript` to generate typed clients from OAS spec

### Actions

- [ ] Create API versioning reference under `api-design/references/`
- [ ] Create app versioning reference (could live in `git-workflow/references/versioning.md`)
- [ ] Create auto-documentation reference under `api-design/references/` or a new `doc-writing/references/api-docs.md`
- [ ] Consider a `/generate-api-docs` command that runs OAS generation for the current project

---

## 28. GitHub Actions for CI/CD Template

Every project with code should have automated PR review via Claude Code's GitHub Actions.

### Workflow Files for Repo Template

**`.github/workflows/claude-review.yml`** — General PR review:
- Triggers on: PR opened, updated, @claude mentioned
- Uses `anthropics/claude-code-action@v1`
- Respects repo's CLAUDE.md for project-specific rules
- Reviews for bugs, security, performance, style

**`.github/workflows/security-review.yml`** — Security-focused review:
- Triggers on: every PR
- Uses `anthropics/claude-code-security-review@main`
- Comments findings directly on the PR
- Lighter weight than full review

### Template Integration

- Add both workflow files to your GitHub repo template
- Include setup instructions for adding `ANTHROPIC_API_KEY` secret
- Include a CLAUDE.md stub with baseline code standards so every repo inherits minimum review quality
- Consider `pnpm audit` / `uv pip audit` as additional CI steps

### Actions

- [ ] Create both workflow files
- [ ] Add to GitHub repo template
- [ ] Document setup in template README
- [ ] Test with a real PR

---

## Priority Order

Suggested sequence for working through these:

### Completed (v1)
1. ~~Validation script (#2)~~ — done, 236 checks across 9 categories
2. ~~Agent memory directories (#3)~~ — done, all 24 agents
3. ~~CONTEXT.md (#5)~~ — done, includes parallelism rules
4. ~~Agent parallelism map (#12)~~ — done, in CONTEXT.md
5. ~~Threat-modeler agent (#14)~~ — done, agent + dispatch + memory
6. ~~Eval suite (#1)~~ — done, all tiers + review challenges
7. ~~Token tracking (#13)~~ — done, result.json scaffold
8. ~~Handoff protocol (#8)~~ — done, docs/HANDOFF-PROTOCOLS.md
9. ~~Failure modes (#9)~~ — done, docs/FAILURE-MODES.md
10. ~~Skill chains (#7)~~ — done, docs/SKILL-CHAINS.md + frontmatter
11. ~~Staleness detection (#10)~~ — done, `last_verified` on all skills
12. ~~Improvements backlog (#4)~~ — done, seeded with 3 suggestions
13. ~~Plans hygiene (#6)~~ — done

### Next Up (v2 — system infrastructure)
14. **Path-scoped rules** (#15) — move domain instructions out of CLAUDE.md into `.claude/rules/` with globs
15. **TypeScript strictness rules** (#21) — `.claude/rules/typescript.md` with path scope
16. **Python project structure rules** (#22) — `.claude/rules/python.md` with path scope
17. **Hooks for enforcement** (#17) — TDD enforcement, pre-commit validation, console.log/print guards
18. **Skill frontmatter modernization** (#18) — `context: fork`, `paths:`, `allowed-tools:` across all skills
19. **Dynamic context in skills** (#16) — `!`command`` syntax for live state injection

### Next Up (v2 — skill and reference content)
20. **Dependency management reference** (#20) — shared across backend, frontend, automation skills
21. **Error handling patterns** (#24) — backend + frontend references, production hygiene rules
22. **DynamoDB patterns reference** (#25) — highest-priority database reference
23. **Next.js patterns reference** (#23) — App Router patterns for frontend-engineering
24. **API versioning + auto-documentation** (#27) — versioning reference + OAS generation patterns
25. **GitHub Actions CI/CD template** (#28) — claude-code-action + security-review workflows

### Later (v2 — expand coverage)
26. **Additional database references** (#25) — MongoDB, PostgreSQL
27. **Google Cloud references** (#26) — GCP infra + security
28. **Additional project structure references** (#23) — React patterns, API frameworks, AI project structure
29. **App versioning + GitHub releases** (#27) — semver, git tags, auto-changelog
30. **Run remaining evals** — Tier 2, 3, 4 with updated skills
31. **Agent SDK evaluation** (#19) — revisit if Tier 3/4 evals show dispatch failures

### Deferred / Future
- Cross-agent memory (#11) — revisit when proven needed in practice
- CLAUDE.md splitting (#5 proposed split) — evaluate after rules/ directory is in place
- React Native patterns (#23) — when mobile projects start
- Desktop app patterns (#23) — when Electron/Tauri projects start
- Azure cloud references (#26) — when needed
- Monorepo patterns (#23) — when workspace projects start
