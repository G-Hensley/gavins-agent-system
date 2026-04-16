# VAST Methodology & STRIDE Threat Modeling

Source: Microsoft STRIDE model, OWASP Threat Modeling, VAST methodology

VAST (Visual, Agile, and Simple Threat) modeling is designed for modern DevOps — automated, integrated, and scalable.

## Core Principles

- **Visual**: Map threats using diagrams so teams can see attack vectors clearly
- **Agile**: Integrates into sprints and CI/CD — a continuous practice, not a one-time event
- **Simple**: Reduces complexity so developers (not just security teams) can participate

## The VAST Process

### Step 1: System Mapping

Create a visual representation of the system:

```
[User Browser] → [CDN/WAF] → [API Gateway] → [Application Server] → [Database]
                                    ↓                    ↓
                              [Auth Service]     [External APIs]
                                    ↓
                              [Token Store]
```

Mark trust boundaries with `||`:

```
[User] || [API Gateway] || [App Server] || [Database]
 Public     DMZ            Internal        Data Layer
```

Every boundary crossing is a potential attack point.

### Step 2: Threat Identification (STRIDE per Element)

For each component and data flow, apply STRIDE:

| Threat | Question | Example |
|---|---|---|
| **S**poofing | Can someone impersonate a legitimate user/service? | Stolen JWT, forged API key |
| **T**ampering | Can data be modified without detection? | Man-in-the-middle, parameter manipulation |
| **R**epudiation | Can actions be performed without audit trail? | Missing logging on admin actions |
| **I**nformation Disclosure | Can sensitive data leak? | Error messages with stack traces, unencrypted PII |
| **D**enial of Service | Can the system be overwhelmed? | Missing rate limiting, unbounded queries |
| **E**levation of Privilege | Can users gain unauthorized access? | IDOR, broken function-level auth |

### Step 3: Severity Scoring

| Severity | Criteria | Response |
|---|---|---|
| **Critical** | Exploitable remotely, leads to data breach or full system compromise | Fix immediately, block release |
| **High** | Exploitable with some conditions, significant data exposure | Fix before next release |
| **Medium** | Requires internal access or specific conditions | Schedule for upcoming sprint |
| **Low** | Theoretical risk, minimal impact | Add to backlog |

### Step 4: Mitigation Mapping

For each threat, document:
```
Threat: [description]
Severity: [Critical/High/Medium/Low]
Component: [which component is affected]
Mitigation: [specific technical fix]
Validation: [how to verify the fix works]
Owner: [who implements it]
Status: [Open/In Progress/Mitigated/Accepted]
```

## Threat Model Document Template

```markdown
# Threat Model: [System Name]
**Date:** YYYY-MM-DD
**Version:** 1.0
**Author:** [name]
**Status:** Draft | In Review | Approved

## System Overview
[1-2 paragraphs: what the system does, who uses it]

## System Diagram
[Visual diagram with trust boundaries marked]

## Assets
| Asset | Sensitivity | Location |
|---|---|---|
| User credentials | Critical | Auth service + token store |
| Customer PII | High | Database |
| API keys | Critical | Secrets Manager |

## Trust Boundaries
| Boundary | From | To | Controls |
|---|---|---|---|
| Public → DMZ | User browser | API Gateway | WAF, rate limiting |
| DMZ → Internal | API Gateway | App Server | Auth, input validation |
| Internal → Data | App Server | Database | Parameterized queries, least privilege |

## Threats and Mitigations
| ID | Threat | STRIDE | Severity | Component | Mitigation | Status |
|---|---|---|---|---|---|---|
| T-001 | [description] | [S/T/R/I/D/E] | [severity] | [component] | [fix] | [status] |

## Accepted Risks
[Threats acknowledged but not mitigated, with justification]

## Review Schedule
- Next review: [date]
- Trigger events: major architecture changes, new external integrations, security incidents
```

## STRIDE Deep Dive by Component

Source: Microsoft Threat Modeling Tool (learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats)

**API endpoints**: Spoofing (forged JWTs, stolen API keys), Tampering (parameter manipulation, request body injection), Information Disclosure (verbose errors, excessive data in responses), DoS (missing rate limits, expensive queries), EoP (BOLA, broken function-level auth)

**Databases**: Tampering (SQL injection, mass assignment), Information Disclosure (unencrypted backups, excessive SELECT), Repudiation (no audit logging on writes), EoP (app running as DB admin)

**Authentication services**: Spoofing (credential stuffing, session hijacking), Tampering (token manipulation, algorithm confusion in JWT), Repudiation (no login audit trail), Information Disclosure (user enumeration via error messages)

**External integrations**: Spoofing (compromised third-party API), Tampering (MITM on unencrypted connections), Information Disclosure (over-sharing data with third parties), DoS (third-party outage cascading to your system)

**File uploads**: Tampering (malicious file content), Information Disclosure (metadata leakage), DoS (oversized uploads consuming storage), EoP (path traversal, unrestricted file types enabling RCE)

**Message queues/event streams**: Spoofing (unauthorized message producers), Tampering (message modification in transit), Repudiation (untracked message processing), DoS (queue flooding)

## Common Threat Patterns by Architecture

**Serverless (Lambda + API Gateway + DynamoDB)**:
- Overpermissive Lambda roles → least-privilege per function
- Event injection (untrusted event data) → validate all event input
- Cold start timing attacks → not usually critical but document
- Function-level DoS → reserved concurrency, API Gateway throttling

**SPA + REST API**:
- XSS → CSP, output encoding, DOMPurify
- CSRF → SameSite cookies, anti-CSRF tokens
- Token storage → HttpOnly cookies, not localStorage
- API enumeration → rate limiting, authentication required for all endpoints

**Microservices**:
- Service-to-service auth → mTLS or signed JWTs, not shared secrets
- Network segmentation → private subnets, security groups per service
- Cascading failures → circuit breakers, timeouts, bulkheads
- Data consistency → eventual consistency threats, duplicate processing

## Continuous Integration

VAST is not a one-time exercise:
- **New feature**: update threat model during architecture review
- **New integration**: assess trust boundaries with external system
- **Security incident**: review if existing threats were underrated
- **Quarterly**: review full threat model for staleness
- **Pre-release**: validate all Critical/High mitigations are implemented
