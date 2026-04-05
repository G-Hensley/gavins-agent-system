# GCP Infrastructure

## AWS → GCP Service Mapping
| AWS | GCP |
|---|---|
| Lambda | Cloud Functions (event-driven) / Cloud Run (containerized) |
| DynamoDB | Firestore (document) / Bigtable (wide-column, high throughput) |
| S3 | Cloud Storage |
| Cognito | Identity Platform (Firebase Auth) |
| API Gateway | API Gateway / Cloud Endpoints |
| Secrets Manager | Secret Manager |
| CloudWatch | Cloud Logging + Cloud Monitoring |
| IAM Roles | Service Accounts |

## Cloud Run
- Container-based serverless — deploy any language/runtime
- Set `--concurrency` per instance (default 80); tune based on CPU/memory pressure
- Use `--min-instances 1` to eliminate cold starts for latency-sensitive services
- `--max-instances` caps scaling; set to control cost and downstream rate limits
- Use `--cpu-boost` for faster cold starts on gen2
- Health checks: `/healthz` or liveness probe on container port

## Cloud Functions
- Prefer **gen2** (longer timeouts, larger instances, VPC support)
- Triggers: HTTP, Pub/Sub, Cloud Storage (object events), Firestore, Eventarc
- Use service account per function — not the default compute SA
- Set `--timeout` and `--memory` explicitly; don't rely on defaults
- Deploy via `gcloud functions deploy` or Cloud Build trigger

## Firestore
- Collection → Document → Subcollection hierarchy
- Design around queries: composite indexes required for multi-field filters
- Security Rules enforce access at the document level — don't skip them
- Use `FieldValue.serverTimestamp()` not client time
- Avoid large documents (1 MB limit); split with subcollections

## Cloud Storage
- Buckets are globally namespaced; use project-prefix naming
- Block public access unless CDN or static hosting intentional
- Signed URLs for temporary access: `gsutil signurl` or client library
- Lifecycle rules: transition to Nearline/Coldline/Archive or delete on age
- Cloud CDN: attach backend bucket, enable CDN checkbox, set cache TTLs

## IAM
- Use **service accounts** per workload — never reuse across services
- No user-managed service account keys in code or CI — use Workload Identity Federation
- Workload Identity for GKE: bind SA → Kubernetes SA instead of exporting keys
- Custom roles when predefined roles are too broad
- Audit with IAM Recommender (removes unused permissions)
- Org policies: `constraints/iam.allowedPolicyMemberDomains` restricts who can be granted access

## Secret Manager
- Store all secrets here — never in env vars baked into images or source
- Version secrets; roll to a new version rather than overwrite in-place
- Access via client library: `secretmanager.SecretManagerServiceClient`
- IAM permission `roles/secretmanager.secretAccessor` on the specific secret resource, not project-wide
- Enable audit logging on Secret Manager API for access tracking
