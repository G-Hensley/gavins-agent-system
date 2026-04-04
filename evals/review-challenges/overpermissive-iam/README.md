# Overpermissive IAM Review Challenge

Seeded-defect evaluation for the `cloud-security-reviewer` agent.

## What This Is

A CloudFormation template (`template.yaml`) for a realistic serverless application: API Gateway + Lambda + DynamoDB + S3. Four IAM/security defects have been planted at varying difficulty levels. One properly scoped role is included as a false-positive control.

The template is designed to look like a plausible production deployment. Issues are embedded in realistic resource configurations, not in obvious toy examples.

## What the Reviewer Should Find

| Defect | Resource | Difficulty | Expected Severity |
|---|---|---|---|
| Lambda execution role with `Action: "*"` and `Resource: "*"` | `LambdaExecutionRole` | Easy | Critical |
| S3 bucket policy allowing public read on user-data bucket | `UserDataBucketPolicy` | Medium | Critical |
| Lambda env var with hardcoded database password | `ProcessorFunction` | Medium | High |
| Cross-account assume role with overly broad trust policy | `CrossAccountReplicationRole` | Hard | High |
| Properly scoped DynamoDB read-only role (control) | `ReportsReadRole` | N/A | None |

## Scoring

| Result | Points |
|---|---|
| Correctly identifies wildcard IAM role (Critical) | +3 |
| Correctly identifies public S3 bucket policy (Critical) | +3 |
| Correctly identifies hardcoded secret in env var (High) | +2 |
| Correctly identifies overly broad cross-account trust (High) | +2 |
| Does NOT flag the clean `ReportsReadRole` | +2 |
| False positive on `ReportsReadRole` | -2 |
| Missed wildcard IAM | -3 |
| Missed public S3 | -3 |
| Missed hardcoded secret | -2 |
| Missed cross-account trust | -1 |

**Max score: 12**

- 11-12: Excellent -- catches all planted issues including the subtle trust policy flaw
- 8-10: Good -- catches critical issues, may miss the hard cross-account finding
- 5-7: Needs improvement -- missing significant misconfigurations
- <5: Failing -- not suitable for cloud infrastructure review

## How to Run

Dispatch the reviewer using the exact prompt in `eval-prompt.md`, pointing it at `template.yaml`. Compare output against `expected-findings.md`.

No deployment required -- this is a static analysis challenge against the CloudFormation template file.
