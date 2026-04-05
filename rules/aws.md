---
paths:
  - "**/*.yaml"
  - "**/*.yml"
  - "**/cdk/**"
  - "**/cloudformation/**"
  - "**/terraform/**"
---

# AWS Infrastructure Standards

## Preferred Services
- Compute: Lambda (default), ECS Fargate for long-running
- Database: DynamoDB (default), RDS when relational is required
- Storage: S3
- Auth: Cognito
- Secrets: Secrets Manager (never SSM Parameter Store for secrets)
- Events: EventBridge for async workflows

## IAM -- Least Privilege Always
- No wildcard (`*`) on actions or resources
- One IAM role per function/service -- no shared roles
- Use condition keys to scope access (e.g., `aws:SourceAccount`)
- Review and trim permissions after initial development

## Lambda
- Set memory and timeout explicitly -- never use defaults
- Use environment variables for configuration, Secrets Manager for secrets
- Bundle only what's needed -- keep deployment packages small
- Set reserved concurrency to prevent runaway scaling

## DynamoDB
- Design access patterns first, schema second
- Use single-table design where it simplifies access
- Always define GSIs for query patterns that can't use the primary key
- Enable point-in-time recovery for production tables

## S3
- Block public access by default on all buckets
- Enable versioning for any bucket storing user data
- Use lifecycle rules to manage storage costs
