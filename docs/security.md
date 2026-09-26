# Security architecture

## Supply chain

```text
source
  |
  +-- gitleaks
  +-- semgrep
  +-- dependency scan
  +-- IaC scan
  |
  v
build
  |
  +-- SBOM
  +-- Trivy
  +-- Cosign
  |
  v
ECR
  |
  v
GitOps
```

## AWS

- OIDC instead of static AWS keys
- separate roles by function
- deny-by-default trust policies
- CloudTrail enabled
- GuardDuty enabled
- Security Hub enabled where appropriate
- IAM Access Analyzer
- KMS encryption
- S3 public access blocked
- EKS endpoint private
- Secrets Manager for application secrets

## EKS

- private worker subnets
- Pod Identity
- NetworkPolicy
- Pod Security Admission
- non-root containers
- read-only filesystem where possible
- no privileged containers
- resource requests/limits
- restricted RBAC
- separate namespaces
- image digest pinning

## Container

Images must:
- use minimal base images
- run as non-root
- have no package manager in final layer where possible
- have deterministic dependencies
- produce an SBOM
- be vulnerability scanned
- be signed

## Android

Protect:
- upload/signing keys
- Play service account
- API secrets
- debug signing keys

Do not put server secrets into the Android APK/AAB.

Assume anything shipped to a mobile device can eventually be inspected.

## Secrets

Secrets should flow:

```text
AWS Secrets Manager
        |
        v
External Secrets Operator
        |
        v
Kubernetes Secret
        |
        v
Pod
```

Do not store plaintext secrets in Git.

## Incident response

When compromise is suspected:

1. stop deployment
2. revoke compromised credentials
3. rotate secrets
4. isolate affected workload
5. preserve logs
6. inspect CloudTrail
7. inspect GitHub audit events
8. inspect ECR and artifact provenance
9. redeploy from a known-good immutable artifact
10. document root cause and corrective actions
