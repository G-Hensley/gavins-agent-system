---
name: create-agent
description: Scaffold new Claude Code agents. Use when creating a new agent definition, adding a specialist agent to the system, or when the user says "create an agent", "new agent", or "add an agent". Generates the agent .md file following established conventions.
last_verified: 2026-04-04
---

# Create Agent

Scaffold a new agent definition file at `~/.claude/agents/<name>.md`.

## Process

### 1. Gather Requirements

Determine the following (ask the user if not provided):
- **Name**: kebab-case identifier (e.g., `api-tester`, `migration-engineer`)
- **Role**: what this agent does in one sentence
- **Domain**: what kind of work it handles
- **Skills**: which skills from `~/.claude/skills/` it should load
- **Model**: opus (complex reasoning, design, architecture), sonnet (implementation, review), haiku (simple/fast tasks like docs)
- **Tools**: which tools it needs (default: Read, Write, Edit, Bash, Grep, Glob)
- **Memory**: what memory scope it uses — `user` (most agents), `project` (task-scoped agents like implementer)

### 2. Check for Conflicts

Before creating:
- Verify no agent with the same name exists in `~/.claude/agents/`
- Check that the role doesn't overlap significantly with an existing agent
- Verify all listed skills exist in `~/.claude/skills/`
- If a conflict exists, tell the user and ask how to proceed

### 3. Generate the Agent File

Use the template from `references/agent-template.md`. Follow these conventions:

**Frontmatter:**
- `name`: matches the filename (without `.md`)
- `description`: 1-2 sentences. Start with role title. Include when to use and what it does. This is what the skill-router and Agent tool use to decide dispatch
- `tools`: comma-separated list. Only include tools the agent actually needs
- `model`: opus | sonnet | haiku
- `skills`: YAML list of skill names (must exist in `~/.claude/skills/`)
- `memory`: user | project

**Body sections (in order):**
1. **Opening line**: "You are a [senior] [role]." — sets the agent's identity
2. **Before Starting** (optional): preconditions or setup steps
3. **How You Work** or **What You Create**: the agent's core process
4. **What You Don't Do**: explicit anti-patterns and boundaries
5. **Output** (optional): what the agent delivers and where
6. **Closing line** (optional): memory update instruction or status report format

**Conventions:**
- Total file must be under 200 lines (including frontmatter)
- Body should be 30-60 lines — concise and actionable
- Use imperative mood ("Read the spec", not "You should read the spec")
- No filler text — every line should change behavior
- Anti-patterns section prevents scope creep and overlap with other agents

### 4. Register in Skill Router

After creating the agent, update `~/.claude/skills/skill-router/SKILL.md`:
- Add a routing line in Step 2 mapping the agent's domain to its name
- Follow the existing format: `**Domain description** -> \`skill-name\``

### 5. Update CLAUDE.md Agent Dispatch Table

If the agent fits a clear dispatch pattern, add a row to the Agent Dispatch Guide table in `~/.claude/CLAUDE.md`.

### 6. Verify

- Read the generated file back and confirm it follows conventions
- Confirm all referenced skills exist
- Confirm the file is under 200 lines

## Reference Files

- `references/agent-template.md` — Starter template with frontmatter and body structure
