# GCP Security

## IAM Best Practices
- One service account per service — never share SAs across workloads
- No user-managed service account keys in code, CI env vars, or repos
- Workload Identity Federation for GKE and CI/CD (GitHub Actions, Cloud Build) — eliminates key files
- Domain-restricted sharing: set `constraints/iam.allowedPolicyMemberDomains` org policy to block external users
- Review IAM Recommender findings monthly — removes permissions unused for 90 days
- Principle of least privilege: prefer predefined roles, use custom roles when predefined are too broad

## Network Security
- **VPC Service Controls**: create a service perimeter around sensitive APIs (Firestore, Cloud Storage, BigQuery) to prevent data exfiltration
- **Private Google Access**: allow VMs without external IPs to reach Google APIs over internal network
- **Cloud Armor WAF**: attach to HTTPS Load Balancers; use OWASP ruleset + rate-limiting policies
- Firewall rules: default-deny ingress, allowlist only required ports and source ranges
- Use VPC peering or Private Service Connect instead of public endpoints for internal services

## Data Protection
- **CMEK (Customer-Managed Encryption Keys)**: use Cloud KMS keys for Cloud Storage, Firestore, BigQuery when compliance requires key control
- **DLP API**: scan uploads and stored data for PII (credit cards, SSNs, emails) before processing or storing
- Data residency: set `constraints/gcp.resourceLocations` org policy to restrict resource creation to approved regions
- Enable object versioning on Cloud Storage buckets holding sensitive data
- Delete data at the source — do not rely solely on access controls as the last line of defense

## Logging and Monitoring
- **Cloud Audit Logs**: enable Data Read/Write audit logs for sensitive APIs — off by default for most services
- **Cloud Logging**: structured JSON logs, export to Cloud Storage or BigQuery for long-term retention
- **Security Command Center**: enables findings for misconfigurations, vulnerabilities, and threats across the org
- **VPC Flow Logs**: enable per-subnet for network traffic visibility; tune sampling rate to manage cost
- Set log-based alerts on: IAM policy changes, SA key creation, firewall rule modifications

## Common Misconfigurations
- **Public Cloud Storage buckets**: `allUsers` or `allAuthenticatedUsers` IAM bindings expose data publicly — block at org policy level
- **Overly permissive firewall rules**: `0.0.0.0/0` ingress on SSH (22) or RDP (3389) — restrict to known IPs or use IAP
- **`allUsers` IAM bindings**: grants access to the entire internet; flag any binding with this principal
- **Missing org policies**: without org policies, any project member can create public resources or export SA keys
- **Default service account usage**: Compute Engine default SA has Editor role by default — disable or restrict it
