# Production readiness checklist

## AWS

- [ ] Dedicated production AWS account
- [ ] CloudTrail organization trail
- [ ] GuardDuty
- [ ] Security Hub
- [ ] IAM Access Analyzer
- [ ] AWS Config where required
- [ ] centralized logs
- [ ] KMS keys and rotation policy
- [ ] VPC flow logs
- [ ] backup policy
- [ ] DR strategy
- [ ] budgets and cost alerts

## Network

- [ ] 3 AZs
- [ ] private worker nodes
- [ ] private database subnets
- [ ] no public database
- [ ] WAF
- [ ] TLS 1.2+
- [ ] security groups least privilege
- [ ] NetworkPolicy
- [ ] egress control

## EKS

- [ ] supported Kubernetes version
- [ ] Pod Identity
- [ ] EBS CSI
- [ ] AWS Load Balancer Controller
- [ ] metrics server
- [ ] Pod Security Admission
- [ ] PDB
- [ ] HPA
- [ ] topology spread
- [ ] resource requests/limits
- [ ] cluster autoscaling strategy

## GitHub

- [ ] protected main
- [ ] protected environments
- [ ] production approvals
- [ ] OIDC
- [ ] separate runner pools
- [ ] runner isolation
- [ ] secret variables protected
- [ ] CODEOWNERS
- [ ] security gates
- [ ] artifact retention
- [ ] audit events

## Application

- [ ] backward-compatible DB migrations
- [ ] API versioning
- [ ] idempotency for critical writes
- [ ] timeouts
- [ ] retries with jitter
- [ ] circuit breaking where appropriate
- [ ] rate limiting
- [ ] authentication
- [ ] authorization
- [ ] input validation

## Android

- [ ] Play App Signing
- [ ] protected upload key
- [ ] internal track
- [ ] closed testing
- [ ] staged production rollout
- [ ] crash/ANR telemetry
- [ ] feature flags
- [ ] API compatibility strategy

## Observability

- [ ] metrics
- [ ] logs
- [ ] traces
- [ ] mobile RUM
- [ ] web RUM
- [ ] SLOs
- [ ] alert routing
- [ ] on-call
- [ ] runbooks
- [ ] dashboards
- [ ] synthetic checks

## DR

- [ ] RDS backups
- [ ] restore tests
- [ ] cross-AZ
- [ ] cross-region decision
- [ ] RTO documented
- [ ] RPO documented
- [ ] game day / DR exercise
