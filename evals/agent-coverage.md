---
# Agent Coverage Matrix

Maps each of the 24 specialist agents to the tier(s) and review challenges where it is tested.
A dash means the agent is not the primary subject at that tier.

| Agent | Tier 1 | Tier 2 | Tier 3 | Tier 4 | Review Challenge |
|---|---|---|---|---|---|
| ai-engineer | ChatBot CLI | — | RAG system | Full-stack app | — |
| automation-engineer | CLI calculator | File watcher | — | — | — |
| backend-engineer | REST endpoint | — | Game server API | Full-stack app | — |
| database-engineer | Schema + migrations | — | Multi-table design | Full-stack app | — |
| devops-engineer | Dockerfile | CI pipeline | — | Full-stack app | — |
| devsecops-engineer | — | Secrets scanning | Security pipeline | — | — |
| doc-writer | README | API docs | Architecture docs | Full-stack app | — |
| frontend-engineer | — | Tic-tac-toe UI | Three.js scene | Full-stack app | — |
| implementer | — | — | — | Full-stack app | — |
| qa-engineer | Unit test suite | E2E test plan | Load test strategy | Full-stack app | — |
| architect | — | — | Game architecture | Full-stack app | — |
| product-manager | — | — | Game PRD | Full-stack app | — |
| uiux-designer | — | Tic-tac-toe design | — | Full-stack app | — |
| threat-modeler | — | Secrets scanning | Game threat model | Full-stack app | — |
| appsec-reviewer | — | — | — | — | dependency-vuln |
| architecture-reviewer | — | — | Review game design | — | — |
| backend-security-reviewer | — | — | — | — | sql-injection |
| cloud-security-reviewer | — | — | — | — | overpermissive-iam |
| code-explorer | — | Explore tic-tac-toe | Explore game codebase | — | — |
| code-quality-reviewer | — | — | — | — | code-quality-issues |
| frontend-security-reviewer | — | — | — | — | xss-vulnerability |
| plan-reviewer | — | — | Review game plan | — | — |
| product-reviewer | — | — | Review game PRD | — | — |
| spec-reviewer | — | — | — | — | spec-deviation |

## Coverage Notes

- Tier 4 (full-stack app) is the integration tier — most agents appear as participants.
  The primary eval target at Tier 4 is the `subagent-driven-development` orchestration,
  not any individual agent.
- Agents with no Tier 1 entry (`architect`, `frontend-engineer`, etc.) are not
  meaningful in isolation; they require upstream artifacts (PRD, design system) to operate.
- Review challenge agents (`*-reviewer`) are only tested against seeded defect artifacts.
  Their Tier 1–4 appearances as co-participants in larger workflows are not individually scored.
