# Agent System — Status Tracker

Current status of improvements from [IMPROVEMENTS.md](./IMPROVEMENTS.md) and eval runs.

Last updated: 2026-04-04

---

## Improvements Roadmap

| # | Improvement | Status | Notes |
|---|---|---|---|
| 1 | Eval suite — structure | Done | evals/ with README, run-eval.sh, agent-coverage.md |
| 1 | Eval suite — Tier 1 prompts | Done | 4 evals: cli-calculator, rest-endpoint, dockerfile, chatbot-cli |
| 1 | Eval suite — Tier 2 prompts | Done | 3 evals: tic-tac-toe, file-watcher, secrets-scanning |
| 1 | Eval suite — Tier 3 prompts | Done | 3 evals: snake-game, threejs-scene, rag-system |
| 1 | Eval suite — Tier 4 prompts | Done | 1 eval: task-manager-app |
| 1 | Review challenges (6/6) | Done | sql-injection, xss, iam, deps, spec-deviation, code-quality |
| 2 | Validation script | Done | scripts/validate.sh — 236 checks across 9 categories |
| 2 | install.sh improvements | Done | --dry-run, --verify, --help flags |
| 3 | Agent memory directories | Done | All 24 agents have agent-memory/<name>/MEMORY.md |
| 4 | Improvements backlog bootstrap | Done | README, 3 seeded suggestions, system/ directory |
| 5 | CONTEXT.md | Done | Pipeline, parallelism, architecture, eval system |
| 6 | Plans directory hygiene | Done | Old session plans removed |
| 7 | Skill composition & dependencies | Done | docs/SKILL-CHAINS.md + `follows:` frontmatter on 5 skills |
| 8 | Handoff protocols | Done | docs/HANDOFF-PROTOCOLS.md + ## Handoff in 5 agent files |
| 9 | Failure mode documentation | Done | docs/FAILURE-MODES.md — 7 scenarios with escalation |
| 10 | Skill staleness detection | Done | `last_verified` on all skills + validate.sh Check 9 |
| 11 | Cross-agent memory | Deferred | By design — revisit when proven needed |
| 12 | Agent parallelism map | Done | Documented in CONTEXT.md |
| 13 | Token tracking | Done | result.json scaffold + --results flag in run-eval.sh |
| 14 | Threat-modeler agent | Done | agents/threat-modeler.md + dispatch table + memory |

---

## Eval Runs

### Review Challenges (2026-04-03)

| Challenge | Target Agent | Planted | Caught | False Pos | Bonus | Grade |
|---|---|---|---|---|---|---|
| SQL Injection | backend-security-reviewer | 3 | 3 | 0 | 0 | PERFECT |
| XSS Vulnerability | frontend-security-reviewer | 3 | 3 | 0 | 0 | PERFECT |
| Overpermissive IAM | cloud-security-reviewer | 4 | 4 | 0 | 4 | EXCEEDED |
| Dependency Vulns | appsec-reviewer | 6 | 6 | 0 | 0 | PERFECT |
| Spec Deviation | spec-reviewer | 5 | 5 | 0 | 1 | STRONG PASS |
| Code Quality | code-quality-reviewer | 7 | 7 | 0 | 2 | EXCEEDED |

**Totals: 28/28 planted findings, 0 false positives, 7 bonus findings.**

### Tier 1 — Single Agent (2026-04-03)

| Eval | Agent | Tests | TDD | Verified | Grade |
|---|---|---|---|---|---|
| CLI Calculator | automation-engineer | 24 pass | Red->Green | 3 demo commands | PASS |
| REST Endpoint | backend-engineer | 15 pass | Red->Green | All routes tested | PASS |
| Dockerfile | devops-engineer | Build+Run | Verified live | curl + whoami | PASS |
| Chatbot CLI | ai-engineer | 18 pass | Red->Green | SDK mocked | PASS |

**4/4 passed. All followed TDD. All verified.**

### Tier 2 — Multi-Agent (not yet run)

| Eval | Target Agents | Status |
|---|---|---|
| Tic-Tac-Toe | uiux-designer -> frontend-engineer | Pending |
| File Watcher | automation-engineer -> devops-engineer | Pending |
| Secrets Scanning | devsecops-engineer -> devops-engineer | Pending |

### Tier 3 — Architecture-First (not yet run)

| Eval | Target Agents | Status |
|---|---|---|
| Snake Game | product-manager -> architect -> backend + frontend + qa | Pending |
| Three.js Scene | uiux-designer -> architect -> frontend-engineer | Pending |
| RAG System | architect -> ai-engineer + database-engineer | Pending |

### Tier 4 — Full Workflow (not yet run)

| Eval | Target Agents | Status |
|---|---|---|
| Task Manager App | Full pipeline (all agents) | Pending |

---

## V2 Improvements (from Claude Code/Cowork research report)

| # | Improvement | Status | Notes |
|---|---|---|---|
| 15 | Path-scoped rules (`.claude/rules/`) | Done | 7 rule files in rules/ with glob-scoped activation |
| 16 | Dynamic context in skills (`` !`cmd` ``) | Done | Live git state, diffs, audit results injected into 5 skills |
| 17 | Hooks for structural enforcement | Done | 3 hook scripts + config template, install.sh merges into settings |
| 18 | Skill frontmatter modernization | Done | fork/opus on 5, allowed-tools on 3, paths on 6, user-invocable on 3 |
| 19 | Agent SDK evaluation | Deferred | Revisit if Tier 3/4 evals show dispatch failures |

## What's Left

### Eval Runs Remaining
- [ ] Run Tier 2 evals (3 multi-agent handoff tests)
- [ ] Run Tier 3 evals (3 architecture-first tests)
- [ ] Run Tier 4 eval (full pipeline end-to-end)

### V2 Priority Order
1. ~~Path-scoped rules (#15)~~ — Done
2. ~~Hooks (#17)~~ — Done
3. ~~Skill frontmatter (#18)~~ — Done
4. ~~Dynamic context (#16)~~ — Done
5. Run remaining evals — validates multi-agent pipelines
6. Agent SDK (#19) — only if evals reveal dispatch failures

### From improvements/ backlog
- [x] Add caching patterns to backend-engineering skill — Done
- [x] Add threat-modeler to Tier 2 evals — Done
- [x] Wire run-eval.sh to execute evals automatically — Done (--run, --run-tier, --run-all)

### Deferred
- Cross-agent memory (#11) — revisit when proven needed in practice
- CLAUDE.md splitting — evaluate after `.claude/rules/` is in place
