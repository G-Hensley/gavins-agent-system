# Project Ideas — Agent System Real-World Tests

Standalone projects to build with Claude Code as real-world tests of the agent system. These aren't evals — they're actual tools to use. Create each as its own repo and let the agents build it.

---

## 1. `project-init` — Project Scaffolder CLI

### What It Is

A Python CLI that creates new project repos with all of Gavin's tooling, rules, and conventions baked in from the first commit. Works with the existing GitHub template repo — the template provides the base, the CLI customizes for project type.

### Why It Matters

Every new project currently requires manual setup: tsconfig, pyproject.toml, CLAUDE.md, .claude/rules/, GitHub Actions, ruff config, Tailwind config, etc. This tool makes "correct by default" automatic.

### Stack

- Python CLI with Typer
- Uses `gh repo create --template` under the hood
- Packaged with uv, installable as a global tool (`uv tool install project-init`)

### Interface

```bash
# Interactive mode — prompts for everything
project-init

# Flag mode — skip prompts
project-init my-api \
  --type python-api \
  --db dynamodb \
  --auth cognito \
  --deploy aws-lambda \
  --ci github-actions

# Minimal — just the basics
project-init my-script --type python-cli
```

### Project Types & What They Generate

**`python-cli`**:
- `src/<name>/` layout with `__init__.py`, `main.py`, `cli.py`
- Typer CLI scaffold with `--help`, `--version`, `--verbose`
- `pyproject.toml` with ruff, pytest, uv config
- `tests/test_cli.py` with first test (TDD-ready)
- `.claude/rules/python.md`

**`python-api`**:
- FastAPI scaffold: `src/<name>/` with `main.py`, `routers/`, `services/`, `models/`
- Pydantic schemas, health endpoint, structured error handling
- `pyproject.toml` with ruff, pytest, uvicorn, uv config
- Layered architecture (handler → service → repository)
- `.claude/rules/python.md`, `.claude/rules/backend.md`

**`nextjs-app`**:
- App Router scaffold: `app/`, `components/`, `lib/`, `hooks/`
- `tsconfig.json` with strict: true, all strict flags
- `tailwind.config.ts` with design system values
- Zustand store scaffold, Zod validation helpers
- `.claude/rules/typescript.md`, `.claude/rules/frontend.md`
- `pnpm` initialized with lock file

**`lambda`**:
- Python or TypeScript Lambda handler
- CDK infrastructure scaffold (L2 constructs)
- SAM local testing config
- `.claude/rules/aws-infra.md`

### Common to All Types

- `CLAUDE.md` stub with project-specific rules
- `.claude/rules/` with relevant path-scoped rules from the agent system
- `.github/workflows/claude-review.yml` (PR review via claude-code-action)
- `.github/workflows/security-review.yml` (security review on every PR)
- `.gitignore` (comprehensive, type-specific)
- `README.md` scaffold
- First test file (so TDD can start immediately)
- Lock files committed (pnpm-lock.yaml or uv.lock)

### Optional Flags

- `--db dynamodb|postgres|mongodb|none` — adds data layer scaffold, migration setup, or DynamoDB table definition
- `--auth cognito|none` — adds auth middleware, Cognito config, protected route examples
- `--deploy vercel|aws-lambda|docker|none` — adds deployment config (Vercel config, CDK stack, or Dockerfile)
- `--ci github-actions` — adds CI pipeline (lint + test + build + audit)
- `--no-claude` — skip CLAUDE.md and .claude/ setup (for non-Claude projects)

### Expected Agent Dispatch

This project should exercise:
- `product-manager` → scope the CLI interface and user stories
- `architect` → design the plugin/template system
- `automation-engineer` → build the CLI
- `qa-engineer` → test all project types and flag combinations
- `doc-writer` → README and --help text

---

## 2. `agent-dashboard` — Agent System Visualization & Monitoring

### What It Is

A Next.js web app that visualizes and monitors the agent system. Shows the agent pipeline graph, token usage, eval results, system health, and memory contents. Deployed to Vercel.

### Why It Matters

The agent system is complex (24 agents, 28 skills, parallelism rules, handoff protocols) and growing. A visual dashboard makes it observable — you can see what's working, what's expensive, and what's stale without reading markdown files.

### Stack

- Next.js 14+ (App Router)
- TypeScript (strict)
- Tailwind CSS + Shadcn UI components
- Recharts for charts/graphs
- React Flow for the agent pipeline graph
- Deployed to Vercel
- Reads from the agent system repo (GitHub API or local filesystem)

### Pages / Views

**Agent Pipeline Graph** (`/`):
- Interactive node graph showing the full workflow: product-manager → architect → threat-modeler → implementers → reviewers → doc-writer
- Color-coded by agent model (Opus = blue, Sonnet = green, Haiku = gray)
- Click an agent node to see: its definition, skills it loads, memory file count, last used date
- Edges show handoff direction; dashed edges show parallel-safe relationships
- Built with React Flow or D3

**Token Usage** (`/tokens`):
- Bar chart: tokens per agent (input vs output) from eval results
- Line chart: token usage trends over time (per eval run date)
- Cost breakdown: estimated $ per agent based on model pricing
- Table: agent | model | avg tokens/task | estimated cost/task
- Pie chart: Opus vs Sonnet vs Haiku token split
- Flag agents that consistently exceed budget thresholds
- Data source: `evals/results/YYYY-MM-DD/result.json`

**Eval Results** (`/evals`):
- Scorecard per eval run: date, tier, pass/fail, defects caught, false positives, review cycles
- Trend line: system score over time (are evals getting better or worse?)
- Per-agent breakdown: which agents passed, which had issues
- Review challenge results: planted vs caught vs false positives
- Data source: `docs/STATUS.md` + `evals/results/`

**System Health** (`/health`):
- Skill staleness: list of all skills with `last_verified` date, color-coded (green < 30 days, yellow < 90 days, red > 90 days)
- Agent memory: file count per agent's memory directory, flag empty memory dirs
- Cross-reference integrity: does every agent reference valid skills? (same checks as validate.sh)
- Recent changes: last 10 git commits to the agent system repo
- File size compliance: any SKILL.md or agent.md over 200 lines?

**Agent Detail** (`/agents/[name]`):
- Full agent definition (rendered markdown)
- Skills loaded by this agent
- Parallelism rules (who can it run with, who must it wait for)
- Handoff protocol (what it expects as input, what it produces)
- Memory contents (rendered markdown)
- Eval history: which evals exercised this agent, results
- Token usage history for this specific agent

**Skill Detail** (`/skills/[name]`):
- SKILL.md content (rendered)
- Reference files list with staleness indicator
- Which agents load this skill
- Frontmatter details (paths, allowed-tools, context, model)

### Data Layer

Two options (decide during architecture):

**Option A: Static generation from repo** (simpler)
- Build script reads the agent system repo at build time
- Generates JSON data files that Next.js static pages consume
- Rebuild on push to the agent system repo (Vercel webhook)
- Pro: No backend, no database, free hosting
- Con: Not real-time, need rebuild for fresh data

**Option B: API routes reading repo** (more dynamic)
- Next.js API routes use GitHub API to read repo contents
- Caches responses with ISR (Incremental Static Regeneration)
- Pro: Always fresh, no build step for data updates
- Con: GitHub API rate limits, slightly more complex

### Design Direction

- Clean, minimal, dashboard aesthetic — not flashy
- Dark mode default (developer tool)
- Dense information display — this is a monitoring tool, not a marketing page
- Shadcn UI components for consistency
- Mobile-responsive but desktop-primary

### Expected Agent Dispatch

This is a full-pipeline project that should exercise nearly every builder agent:
- `product-manager` → PRD with user stories for each view
- `uiux-designer` → design system, layout specs, component hierarchy
- `architect` → data layer decision, page architecture, API design
- `threat-modeler` → since it reads repo data, assess what's exposed
- `frontend-engineer` → all pages and components
- `database-engineer` → if Option B, data caching strategy
- `qa-engineer` → test each page renders correctly, chart data accuracy
- `doc-writer` → README, deployment guide
- Security reviewers → review the deployed app
