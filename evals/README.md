# Agent System Eval Suite

Graded prompts and seeded review challenges that exercise the 24 specialist agents and 28 skills in Gavin's Agent System.

## Why It Exists

The system's value depends on agents being dispatched correctly, following workflow rules, producing quality output, and handing off cleanly. These evals verify that behavior is consistent — especially after changes to agents, skills, or CLAUDE.md instructions.

## Tier Structure

Each tier adds a layer of system complexity:

| Tier | What It Tests | Passing Bar |
|---|---|---|
| **Tier 1 — Single Agent** | One agent receives a focused task and completes it without help | Correct agent dispatched, output meets spec, follows agent-specific rules |
| **Tier 2 — Multi-Agent** | A task requires one agent to hand off to another (e.g., design then implement) | Correct handoff sequence, context preserved across handoff, each agent stays in its lane |
| **Tier 3 — Architecture First** | Task is complex enough to warrant `architect` + `product-manager` before any code is written | Full pipeline: PM -> architect -> reviewer -> implementers, no premature implementation |
| **Tier 4 — Full Workflow** | End-to-end using `subagent-driven-development`: plan, task breakdown, parallel implementation, QA | All 24 agents exercised, task graph correct, parallel execution where applicable |

### Tier 1 — Single Agent (`tier-1-single-agent/`)

Simple, scoped tasks. One agent. No handoffs required. Used to verify that:
- The right agent is selected for the task type
- The agent applies the correct skill(s)
- Output is complete and meets quality bar
- Agent-specific rules are followed (e.g., TDD, line limits, no hardcoded secrets)

### Tier 2 — Multi-Agent (`tier-2-multi-agent/`)

Tasks that naturally span two agents. Used to verify:
- Correct handoff sequence (e.g., `uiux-designer` before `frontend-engineer`)
- Context and artifacts (design system, schema, plan) passed correctly across agents
- No agent overreaches into another's domain

### Tier 3 — Architecture First (`tier-3-architecture-first/`)

Nontrivial features requiring upfront design. Used to verify:
- `product-manager` produces a PRD before any design or code
- `architect` produces a design before implementation begins
- `plan-reviewer`, `product-reviewer`, `architecture-reviewer` are invoked appropriately
- Reviewers catch planted issues in plans and designs

### Tier 4 — Full Workflow (`tier-4-full-workflow/`)

End-to-end build using the `subagent-driven-development` skill. Used to verify:
- Complete pipeline from brief to shipped feature
- `implementer` agents run per task
- QA, docs, and security review all occur
- The `automation-engineer` CLAUDE.md dispatch table is exercised

## Review Challenges (`review-challenges/`)

Pre-built code artifacts with planted defects. Each challenge is a directory containing:

- `artifact.*` — the code, schema, config, or plan under review
- `prompt.md` — the prompt to give the reviewer agent
- `rubric.md` — what the reviewer must find to pass (scoring guide)

Challenges are designed for the specialist reviewer agents:

| Challenge | Target Agent | Planted Issue |
|---|---|---|
| `sql-injection/` | `backend-security-reviewer` | Raw string concatenation in a SQL query |
| `overpermissive-iam/` | `cloud-security-reviewer` | IAM policy with wildcard actions or resources |
| `xss-vulnerability/` | `frontend-security-reviewer` | Unescaped user input rendered to the DOM |
| `dependency-vuln/` | `appsec-reviewer` | Known-vulnerable package version in a manifest |
| `spec-deviation/` | `spec-reviewer` | Implementation that misses or contradicts the spec |
| `code-quality-issues/` | `code-quality-reviewer` | Dead code, unclear naming, oversized function |

A reviewer passes if its output names the specific defect, its location, and the correct remediation. Partial credit applies — see each `rubric.md`.

## Eval Criteria

Each eval is scored across these dimensions:

| Criterion | What Is Checked |
|---|---|
| **Dispatch correctness** | Was the right agent selected? Was the dispatch table used? |
| **Workflow compliance** | Were system rules followed (TDD, design-before-code, etc.)? |
| **Output quality** | Is the artifact complete, correct, and within scope? |
| **Agent-specific rules** | Does output honor the agent's own skill constraints (line limits, naming, etc.)? |
| **Handoff quality** | Was context passed correctly? Did the receiving agent have what it needed? |
| **Review thoroughness** | Did the reviewer find the planted issue? Did it identify location and fix? |

Each dimension is scored 0–2: 0 = missed, 1 = partial, 2 = full credit. Maximum score per eval is 12. Tier weight multipliers apply — see `run-eval.sh` for details.

## Running Evals

```bash
# Show all available evals
./run-eval.sh --list

# Run a specific tier
./run-eval.sh tier-1
./run-eval.sh tier-2

# Run a specific review challenge
./run-eval.sh review-challenges/sql-injection

# Run everything
./run-eval.sh all
```

Results are written to `results/<timestamp>/` as JSON and a human-readable summary. The `results/` directory is gitignored.

## Interpreting Results

Results include a per-eval score breakdown and an aggregate pass rate per tier. A tier is considered passing at 80% aggregate score. Review challenges require finding the planted issue to pass (partial credit does not count toward pass/fail for security reviewers).

After a system change (new agent, updated CLAUDE.md, skill modification), run the affected tier(s) and compare against the baseline in `results/baseline/`.
