# Cloud Security (AWS Focus)

Source: AWS IAM Best Practices, AWS Well-Architected Security Pillar, CIS AWS Foundations Benchmark

## IAM — Least Privilege

Source: AWS IAM Best Practices (docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

**Root account**: lock it away. MFA required. Use only for account-level tasks that require root. Never create access keys for root.

**Temporary credentials over long-term**: use IAM roles, not IAM users with access keys. Roles provide auto-rotating temporary credentials. For workloads outside AWS, use IAM Roles Anywhere or OIDC federation.

**No wildcards**: never `"Action": "*"` or `"Resource": "*"`. Specify exact actions and ARNs.
```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject", "s3:PutObject"],
  "Resource": "arn:aws:s3:::my-bucket/uploads/*",
  "Condition": {
    "Bool": { "aws:SecureTransport": "true" }
  }
}
```

**Policy conditions**: restrict by `aws:SecureTransport` (TLS only), `aws:SourceIp`, `aws:PrincipalTag`, `aws:RequestedRegion`, `aws:MultiFactorAuthPresent`. Defense in depth — even if the action is allowed, conditions add guardrails.

**Permissions boundaries**: when delegating role creation (e.g., dev teams creating Lambda roles), set boundaries that cap maximum permissions. Prevents privilege escalation.

**SCPs for guardrails**: AWS Organizations Service Control Policies enforce maximum permissions across all accounts. Use to block dangerous actions org-wide (disable regions, prevent root usage, require encryption).

**Regular audits**: IAM Access Analyzer to find public/cross-account access. Access Advisor to find unused permissions. Remove unused users, roles, and policies.

## Secrets Management

- **AWS Secrets Manager**: store and auto-rotate database credentials, API keys, tokens
- **SSM Parameter Store** (SecureString): lighter-weight, KMS-encrypted, free tier
- Never hardcode secrets in code, Dockerfiles, or CI configs
- IAM roles for service-to-service auth — no static credentials between AWS services
- Rotate on schedule and on suspected compromise

## Lambda Security

- **One role per function** — not shared roles across Lambdas. Each function gets exactly the permissions it needs.
- Timeout and memory limits — prevent runaway costs from infinite loops or recursive invocations
- **Validate all event input** — Lambda events (API Gateway, SQS, S3) are not trusted input. Apply the same input validation as any API endpoint.
- Environment variable encryption via KMS. Use Secrets Manager for high-sensitivity secrets.
- Reserved concurrency to prevent a single function from consuming all account capacity
- Use Lambda Layers for shared security dependencies (validation, auth middleware)

## S3 Bucket Security

- **Block Public Access** at the account level — `s3:BlockPublicAcls`, `s3:BlockPublicPolicy`, `s3:IgnorePublicAcls`, `s3:RestrictPublicBuckets` all enabled
- Server-side encryption: SSE-S3 (default) or SSE-KMS for key management control
- Bucket policy with explicit deny for sensitive operations:
```json
{
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:*",
  "Resource": ["arn:aws:s3:::sensitive-bucket/*"],
  "Condition": {
    "Bool": { "aws:SecureTransport": "false" }
  }
}
```
- Enable access logging → separate logging bucket
- Presigned URLs for temporary access — never public ACLs
- Object Lock for compliance/immutability requirements
- Versioning enabled for critical buckets (recovery from accidental deletes)

## DynamoDB Security

- Encryption at rest enabled by default (AWS owned key, or CMK via KMS)
- IAM policies scoped to specific tables and operations — not `dynamodb:*`
- Use condition expressions with `attribute_exists` / `attribute_not_exists` to prevent overwrites
- VPC endpoints for private access — no public internet traversal
- Point-in-time recovery enabled for critical tables
- DynamoDB Streams for audit logging of data changes

## VPC and Network

- Databases and internal services in **private subnets** — no public IPs
- Security groups as **allowlists** — deny all by default, open only needed ports/sources
- NACLs for subnet-level deny rules (block known bad IPs, restrict outbound)
- **VPC endpoints** for AWS service access (S3, DynamoDB, Secrets Manager) — avoid NAT gateway for AWS traffic
- VPC Flow Logs enabled → CloudWatch or S3 for network monitoring
- No SSH/RDP to production — use SSM Session Manager for secure shell access

## Cognito / Auth

- MFA required for user pools (TOTP or SMS, prefer TOTP)
- SRP protocol for password authentication — never send plaintext passwords
- Strong password policy: minimum 12 chars, no composition rules
- Short-lived access tokens (1 hour), longer refresh tokens (7-30 days) with rotation
- Custom Lambda triggers for pre-authentication validation and post-authentication logging

## Monitoring & Incident Detection

- **CloudTrail**: enabled in all regions, log to centralized S3 bucket with integrity validation
- **GuardDuty**: enable for threat detection (compromised credentials, crypto mining, unusual API calls)
- **Security Hub**: aggregate findings from GuardDuty, Inspector, Access Analyzer, and third-party tools
- **Config Rules**: continuous compliance checks (encrypted buckets, public access blocks, IAM policies)
- Alert on: root account usage, IAM policy changes, security group changes, failed auth patterns
