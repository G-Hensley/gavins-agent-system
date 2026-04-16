---
name: create-skill
description: Scaffold new Claude Code skills. Use when creating a new skill, adding domain knowledge, or when the user says "create a skill", "new skill", or "add a skill". Generates the SKILL.md, references, and registers the skill.
last_verified: 2026-04-10
disable-model-invocation: true
---

# Create Skill

Scaffold a new skill directory at `~/.claude/skills/<name>/`.

## Process

### 1. Gather Requirements

Determine the following (ask the user if not provided):
- **Name**: kebab-case identifier (e.g., `caching-patterns`, `graphql-design`)
- **Purpose**: reference (domain knowledge) or task (step-by-step workflow)
- **Description**: one sentence — front-load the key use case with trigger keywords
- **Activation**: always loaded, path-scoped (`paths:`), or manual-only (`disable-model-invocation: true`)
- **References**: what supporting reference files are needed (patterns, templates, examples)

### 2. Check for Conflicts

Before creating:
- Verify no skill with the same name exists in `~/.claude/skills/`
- Check that the purpose doesn't overlap significantly with an existing skill
- If the content belongs in an existing skill as a reference file, add it there instead
- If a conflict exists, tell the user and ask how to proceed

### 3. Determine Frontmatter

Select frontmatter fields based on skill type. Use the template from `references/skill-template.md`.

| Field | When to Set |
|-------|-------------|
| `name` | Always — matches directory name |
| `description` | Always — front-load use case, max 250 chars |
| `last_verified` | Always — today's date (YYYY-MM-DD) |
| `paths` | When skill is language/framework-specific |
| `context: fork` | When skill runs complex independent workflows |
| `agent` | When `context: fork` — set agent type |
| `model` | When skill needs a specific model (opus for reasoning) |
| `allowed-tools` | When skill should be restricted (read-only reviews) |
| `disable-model-invocation` | When skill has side effects (deploy, send, commit) |
| `user-invocable: false` | When skill is background knowledge only |
| `argument-hint` | When skill takes arguments |

### 4. Generate SKILL.md

Follow these conventions:
- SKILL.md under 200 lines (including frontmatter)
- Description front-loads keywords users would naturally say
- Process section uses numbered steps with imperative mood
- Reference Files section at bottom lists all supporting files
- No filler — every line should change Claude's behavior

### 5. Generate Reference Files

For each reference file:
- Create in `references/` subdirectory
- Keep each under 200 lines
- Use the same format as existing reference files in the system
- Practical code snippets over theory
- Add a pointer in SKILL.md's Reference Files section

### 6. Register

After creating:
- Update `~/.claude/skills/skill-router/SKILL.md` with a routing line
- Run `~/.claude/scripts/validate.sh` to verify the new skill passes all checks

### 7. Verify

- Read the generated SKILL.md back and confirm it follows conventions
- Confirm total lines under 200
- Confirm all reference files under 200 lines
- Confirm `last_verified` is set to today's date

## Reference Files

- `references/skill-template.md` — Starter template with all frontmatter fields
