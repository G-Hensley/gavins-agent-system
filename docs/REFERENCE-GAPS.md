# Reference File Gaps & Authoritative Sources

Track which skills need better reference files and what authoritative sources to pull from. The goal: Claude should never guess at API signatures, security patterns, or framework conventions — references should contain verified, current information from official docs.

**Strategy**: Use Context7 MCP + official docs to build references with real API examples, not training-data guesses. Each reference should cite its source and version.

---

## Priority 1: Security (high risk if wrong)

### security/references/api-security.md
**Status**: ✅ Enhanced (OWASP API Security Top 10 2023 — all 10 risks with prevention, REST security controls, authentication patterns)
**Sources**: OWASP API Security Top 10 (2023), REST Security Cheat Sheet, Authentication Cheat Sheet

### security/references/appsec.md
**Status**: ✅ Enhanced (OWASP Top 10 2025 — all 10 risks with CWE IDs, prevention measures, anti-patterns table)
**Sources**: OWASP Top 10 (2025), CWE Top 25

### security/references/cloud-security.md
**Status**: ✅ Enhanced (IAM least privilege with real policy JSON, Lambda/S3/DynamoDB/VPC/Cognito security, monitoring stack)
**Sources**: AWS IAM Best Practices, AWS Well-Architected Security Pillar, CIS AWS Foundations Benchmark

### security/references/gcp-security.md
**Sources**:
- GCP Security Best Practices: https://cloud.google.com/security/best-practices
- GCP IAM documentation: https://cloud.google.com/iam/docs
**Gaps**: needs same treatment as AWS — real policy examples, specific controls

### security/references/frontend-security.md
**Status**: ✅ Enhanced (XSS prevention by 5 contexts, nonce/hash CSP, CSRF, secure cookies, security headers, SRI, anti-patterns)
**Sources**: OWASP XSS Prevention Cheat Sheet, OWASP CSP Cheat Sheet, MDN Web Security

### security/references/database-security.md
**Status**: ✅ Enhanced (parameterized queries in 4 languages, NoSQL injection, access control, encryption, connection security)
**Sources**: OWASP SQL Injection Prevention Cheat Sheet, OWASP Query Parameterization Cheat Sheet

### security/references/supply-chain-security.md
**Status**: ✅ Enhanced (dependency evaluation, auditing, lock files, SBOM, package integrity, CI/CD security, Dependabot config)
**Sources**: OWASP A03:2025, OWASP Software Component Verification Standard

### threat-modeling/references/vast-methodology.md
**Status**: ✅ Enhanced (STRIDE per component deep dive, threat patterns by architecture — serverless/SPA/microservices)
**Sources**: Microsoft STRIDE model, OWASP Threat Modeling, VAST methodology

---

## Priority 2: Backend Frameworks (most-used daily)

### backend-engineering/references/node-patterns.md
**Status**: ✅ Enhanced (Express 5.x middleware, error handling, router patterns, Fastify JSON Schema validation, hooks, plugin encapsulation, TypeBox)
**Sources**: Express.js 5.x docs, Fastify docs, Context7

### backend-engineering/references/python-patterns.md
**Status**: ✅ Enhanced (Pydantic V2 models, field/model validators, discriminated unions, ConfigDict, TypeAdapter, FastAPI Depends with Annotated, exception handlers, CORS)
**Sources**: FastAPI docs, Pydantic V2 docs, Context7

### backend-engineering/references/java-patterns.md
**Status**: ✅ Enhanced (Spring Boot 3.x SecurityFilterChain, actuator security, HTTPS enforcement, type-safe config with records, MockMvc testing, slice tests)
**Sources**: Spring Boot 3.5 docs, Spring Security Reference, Context7

### NEW: backend-engineering/references/authentication.md
**Sources**:
- AWS Cognito Developer Guide: https://docs.aws.amazon.com/cognito/latest/developerguide/
- JWT RFC 7519: https://datatracker.ietf.org/doc/html/rfc7519
- OWASP Authentication Cheat Sheet
- OWASP Session Management Cheat Sheet
**Content**: JWT validation, Cognito SRP flow, refresh token rotation, session management

---

## Priority 3: Frontend Frameworks (frequent use)

### frontend-engineering/references/react-patterns.md
**Sources**:
- React official docs: https://react.dev/
- React Server Components: https://react.dev/reference/rsc/server-components
- Context7: `react`, `react-dom`
**Gaps**: needs real hooks examples, server component patterns, Suspense boundaries, error boundaries

### frontend-engineering/references/nextjs-patterns.md
**Sources**:
- Next.js docs: https://nextjs.org/docs
- Next.js App Router: https://nextjs.org/docs/app
- Context7: `next`
**Gaps**: real App Router patterns (layouts, loading, error), Server Actions, metadata API, route handlers

### frontend-engineering/references/state-management.md
**Sources**:
- Zustand docs: https://zustand-demo.pmnd.rs/
- TanStack Query: https://tanstack.com/query/latest/docs/
- Context7: `zustand`, `@tanstack/react-query`
**Gaps**: real Zustand store patterns, TanStack Query setup, when to use which

### NEW: frontend-engineering/references/tailwind-patterns.md
**Sources**:
- Tailwind CSS docs: https://tailwindcss.com/docs
- Context7: `tailwindcss`
**Content**: config setup, custom theme, responsive patterns, dark mode, common component recipes

### NEW: frontend-engineering/references/shadcn-patterns.md
**Sources**:
- Shadcn/UI docs: https://ui.shadcn.com/docs
- Shadcn MCP: use `mcp__Shadcn_UI__*` tools for live component data
**Content**: installation, component usage patterns, theming, composition patterns

---

## Priority 4: Database (critical for correctness)

### database-engineering/references/dynamodb-patterns.md
**Sources**:
- DynamoDB Developer Guide: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/
- DynamoDB Best Practices: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html
- Alex DeBrie's DynamoDB Book patterns
- Context7: `@aws-sdk/client-dynamodb`, `@aws-sdk/lib-dynamodb`
**Gaps**: real SDK v3 code examples, single-table design examples, GSI patterns, transaction examples

### database-engineering/references/postgresql-patterns.md
**Sources**:
- PostgreSQL official docs: https://www.postgresql.org/docs/current/
- Prisma docs: https://www.prisma.io/docs
- Context7: `prisma`, `pg`
**Gaps**: real Prisma schema examples, migration patterns, connection pooling, indexing strategies

### database-engineering/references/mongodb-patterns.md
**Sources**:
- MongoDB docs: https://www.mongodb.com/docs/manual/
- Mongoose docs: https://mongoosejs.com/docs/
- Context7: `mongoose`, `mongodb`
**Gaps**: real schema design patterns, aggregation pipeline examples, indexing

---

## Priority 5: DevOps & Infrastructure

### devops/references/aws-infrastructure.md
**Sources**:
- AWS CDK docs: https://docs.aws.amazon.com/cdk/v2/guide/
- AWS Lambda docs: https://docs.aws.amazon.com/lambda/latest/dg/
- AWS SAM docs: https://docs.aws.amazon.com/serverless-application-model/
- Context7: `aws-cdk-lib`, `@aws-sdk/*`
**Gaps**: real CDK construct examples, Lambda handler patterns, EventBridge rules

### devops/references/docker.md
**Sources**:
- Docker official docs: https://docs.docker.com/
- Dockerfile best practices: https://docs.docker.com/build/building/best-practices/
**Gaps**: multi-stage build examples for each stack (Node/Python/Java), security hardening

### devops/references/github-actions.md
**Sources**:
- GitHub Actions docs: https://docs.github.com/en/actions
- Anthropic Claude Code Action: https://github.com/anthropics/claude-code-action
**Gaps**: real workflow examples for each project type, reusable workflow patterns

### NEW: devops/references/terraform-patterns.md
**Sources**:
- Terraform docs: https://developer.hashicorp.com/terraform/docs
- AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
**Content**: module patterns, state management, AWS resource patterns, security groups

---

## Priority 6: Testing

### qa-engineering/references/e2e-testing.md
**Sources**:
- Playwright docs: https://playwright.dev/docs/intro
- Context7: `@playwright/test`
**Gaps**: real Playwright test examples, page object patterns, CI integration

### qa-engineering/references/test-strategy.md
**Sources**:
- Vitest docs: https://vitest.dev/guide/
- Pytest docs: https://docs.pytest.org/en/stable/
- Context7: `vitest`, `pytest`
**Gaps**: real test setup examples, mocking patterns, fixture patterns

---

## Priority 7: AI/LLM Engineering

### ai-engineering/references/sdk-patterns.md
**Sources**:
- Anthropic API docs: https://docs.anthropic.com/
- Anthropic Python SDK: https://github.com/anthropics/anthropic-sdk-python
- Anthropic TypeScript SDK: https://github.com/anthropics/anthropic-sdk-node
- OpenAI SDK (for compatibility): https://platform.openai.com/docs/
- Context7: `@anthropic-ai/sdk`, `anthropic`
**Gaps**: real SDK examples for tool use, streaming, multi-turn, vision, batch API

### ai-engineering/references/prompt-engineering.md
**Sources**:
- Anthropic prompt engineering guide: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering
- Anthropic cookbook: https://github.com/anthropics/anthropic-cookbook
**Gaps**: real prompt templates with XML tags, chain-of-thought examples, tool-use prompts

---

## Skills with NO references (need assessment)

| Skill | Needs References? | Suggested Content |
|---|---|---|
| brainstorming | Maybe | Brainstorming frameworks (SCAMPER, Six Thinking Hats, mind mapping) |
| executing-plans | No | Process skill — references would duplicate writing-plans |
| parallel-agents | No | Orchestration rules are in CONTEXT.md |
| skill-router | No | Routing logic — no external docs needed |
| subagent-driven-development | Maybe | Example dispatch patterns, handoff templates |
| validation-and-verification | Maybe | Verification checklists per project type |
| writing-plans | Maybe | Plan templates, estimation heuristics |

---

## How to Build References

1. **Use Context7 first** — `resolve-library-id` then `get-library-docs` for any package
2. **Cross-reference official docs** — verify API signatures, default behaviors, deprecations
3. **Include version numbers** — note which version the reference was built against
4. **Real code examples** — not pseudocode. Runnable snippets that follow our stack preferences
5. **Stay under 200 lines** — split into multiple files if needed
6. **Add `last_verified` dates** — so we know when to refresh
7. **Cite the source** — header comment with URL so we can re-verify
