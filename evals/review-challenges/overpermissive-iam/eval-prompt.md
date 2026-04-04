# Eval Prompt

Give the `cloud-security-reviewer` agent this prompt:

---

Review the CloudFormation template at `evals/review-challenges/overpermissive-iam/template.yaml` for IAM and cloud security issues.

The template deploys a serverless order processing backend: API Gateway, Lambda functions, DynamoDB tables, and S3 buckets. Treat this as a production deployment for a commerce platform handling customer PII and payment data.

Identify all IAM, secrets management, and resource policy issues. For each finding:

1. Name the specific CloudFormation resource
2. Quote the exact lines or properties that are misconfigured
3. Explain the attack surface or blast radius
4. Rate severity (Critical / High / Medium / Low)
5. Provide a corrected version of the misconfigured block

Also note any resources that are correctly configured — the reviewer should explicitly confirm which roles or policies are properly scoped.

---

## Expected Agent Behavior

The agent should:

1. Read `template.yaml` and understand the full resource graph (which Lambda uses which role, which bucket has which policy)
2. Evaluate each IAM role's trust policy and permission policy separately
3. Check S3 bucket policies and PublicAccessBlock settings together -- a missing PublicAccessBlockConfiguration combined with a permissive bucket policy is a compound finding
4. Inspect Lambda environment variables for hardcoded secrets
5. Assess cross-account trust policies for missing ExternalId conditions and over-broad principals
6. Explicitly confirm that `ReportsReadRole` is correctly scoped and should NOT be flagged
