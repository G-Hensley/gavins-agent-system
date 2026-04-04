# Expected Findings

## Critical: Wildcard IAM Policy on Lambda Execution Role

- **Resource**: `LambdaExecutionRole`
- **Location**: `Policies[0].PolicyDocument.Statement[0]` (around line 120)
- **Misconfigured block**:
  ```yaml
  - Sid: AllOperations
    Effect: Allow
    Action: "*"
    Resource: "*"
  ```
- **Issue**: The execution role used by `ProcessorFunction` grants every IAM action on every AWS resource in the account. A Lambda compromise, SSRF, or malicious dependency can use this role to exfiltrate all DynamoDB data, delete S3 buckets, create IAM users, exfiltrate secrets, or pivot to any service. This is full account takeover via Lambda.
- **Blast radius**: Entire AWS account.
- **Fix**: Scope to the minimum actions and specific resource ARNs the function actually needs:
  ```yaml
  Policies:
    - PolicyName: ProcessorFunctionPolicy
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Sid: WriteDynamoDB
            Effect: Allow
            Action:
              - dynamodb:PutItem
              - dynamodb:UpdateItem
              - dynamodb:GetItem
            Resource: !GetAtt OrdersTable.Arn
          - Sid: WriteUserDataBucket
            Effect: Allow
            Action:
              - s3:PutObject
            Resource: !Sub "${UserDataBucket.Arn}/exports/*"
          - Sid: BasicLambdaLogs
            Effect: Allow
            Action:
              - logs:CreateLogGroup
              - logs:CreateLogStream
              - logs:PutLogEvents
            Resource: !Sub "arn:aws:logs:${AWS::Region}:${AWS::AccountId}:log-group:/aws/lambda/${AppName}-processor-${Environment}:*"
  ```
- Add `AWSLambdaBasicExecutionRole` managed policy and remove the wildcard policy entirely.

---

## Critical: Public Read on User Data Bucket

- **Resource**: `UserDataBucketPolicy`
- **Location**: `PolicyDocument.Statement[0]` (around line 90)
- **Misconfigured block**:
  ```yaml
  - Sid: AllowPartnerPortalRead
    Effect: Allow
    Principal: "*"
    Action: s3:GetObject
    Resource: !Sub "arn:aws:s3:::${UserDataBucket}/*"
  ```
- **Compound issue**: The `UserDataBucket` resource does not define a `PublicAccessBlockConfiguration`. Combined with a bucket policy that sets `Principal: "*"`, every object in this bucket is publicly readable on the internet. The bucket stores customer profile exports and PII (per the resource comment in the template). This is a data breach waiting to happen.
- **Blast radius**: All customer PII stored in the bucket is publicly accessible without authentication.
- **Fix**:
  1. Add `PublicAccessBlockConfiguration` to the `UserDataBucket` resource:
     ```yaml
     PublicAccessBlockConfiguration:
       BlockPublicAcls: true
       BlockPublicPolicy: true
       IgnorePublicAcls: true
       RestrictPublicBuckets: true
     ```
  2. Replace the wildcard principal with the specific partner's IAM role ARN and add a source condition:
     ```yaml
     - Sid: AllowPartnerPortalRead
       Effect: Allow
       Principal:
         AWS: arn:aws:iam::PARTNER_ACCOUNT_ID:role/partner-portal-read-role
       Action: s3:GetObject
       Resource: !Sub "arn:aws:s3:::${UserDataBucket}/partner-exports/*"
     ```
  3. Restrict the resource path to only the partner-facing prefix, not the entire bucket.

---

## High: Hardcoded Database Password in Lambda Environment Variable

- **Resource**: `ProcessorFunction`
- **Location**: `Properties.Environment.Variables` (around line 158)
- **Misconfigured block**:
  ```yaml
  DB_PASSWORD: "Acm3C0mm3rc3!Pr0d#2024"
  ```
- **Issue**: The database password is stored in plaintext as a CloudFormation environment variable. It will appear in:
  - The CloudFormation template in version control
  - The Lambda function configuration (visible to anyone with `lambda:GetFunctionConfiguration`)
  - CloudFormation stack events and outputs in CloudTrail
  - Any CI/CD system logs that print the template
- **Note**: The `STRIPE_WEBHOOK_SECRET` placeholder on the adjacent line is not exploitable as-is but signals the same pattern -- secrets are being passed as env vars rather than fetched at runtime.
- **Fix**: Store the secret in AWS Secrets Manager and fetch it at Lambda cold start using the Secrets Manager extension or SDK call. Reference the ARN (not the value) in the template:
  ```yaml
  # In template: create/reference the secret
  DatabaseSecret:
    Type: AWS::SecretsManager::Secret
    Properties:
      Name: !Sub "${AppName}/db-credentials/${Environment}"
      Description: Aurora credentials for acme-commerce processor

  # In Lambda env vars: pass the ARN, not the value
  DB_SECRET_ARN: !Ref DatabaseSecret
  # Remove DB_PASSWORD entirely
  ```
  Grant the Lambda role `secretsmanager:GetSecretValue` on that specific secret ARN. Fetch and cache the value in the Lambda handler on cold start.

---

## High: Overly Broad Cross-Account Trust Policy (Missing ExternalId and Principal Restriction)

- **Resource**: `CrossAccountReplicationRole`
- **Location**: `AssumeRolePolicyDocument.Statement[0]` (around line 140)
- **Misconfigured block**:
  ```yaml
  Principal:
    AWS: !Sub "arn:aws:iam::${CrossAccountId}:root"
  Action: sts:AssumeRole
  # No Condition block
  ```
- **Issue**: Using `:root` as the principal means any IAM entity in account `987654321098` -- any user, role, or service -- can assume this role. The intended principal is presumably a specific replication service role, not the entire account. Additionally, the absence of a `Condition` block with an `ExternalId` check makes this role vulnerable to the confused deputy attack: a malicious or compromised service in the target account can assume this role without any shared secret validation.
- **Blast radius**: Any compromised IAM principal in the external account gains read access to the production `OrdersTable` and write access to `OrderArtifactsBucket`.
- **Fix**:
  ```yaml
  AssumeRolePolicyDocument:
    Version: "2012-10-17"
    Statement:
      - Sid: AllowSpecificReplicationRole
        Effect: Allow
        Principal:
          AWS: !Sub "arn:aws:iam::${CrossAccountId}:role/acme-replication-service-role"
        Action: sts:AssumeRole
        Condition:
          StringEquals:
            sts:ExternalId: !Sub "${AppName}-replication-${Environment}"
  ```
  The `ExternalId` value should be a shared secret agreed with the data team and stored in Secrets Manager in both accounts -- not hardcoded in the template. Pin the principal to the specific replication role ARN, not `:root`.

---

## False Positive Check: Clean Least-Privilege Role

- **Resource**: `ReportsReadRole`
- **Status**: Correctly configured. This role should NOT be flagged.
- **Why it is correct**:
  - Trust policy restricts assumption to `lambda.amazonaws.com` only.
  - Attaches `AWSLambdaBasicExecutionRole` for CloudWatch Logs (appropriate managed policy).
  - Custom policy grants only `GetItem`, `Query`, and `Scan` -- no write actions.
  - Resource is scoped to the specific `ReportsTable` ARN, not `*`.
- **Expected result**: The reviewer identifies this role as properly scoped and explicitly calls it out as a control that passes. A false positive flag on this role counts as -2 points.
