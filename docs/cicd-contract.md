# CI/CD Contract

## Main dispatcher

`.github/workflows/main.yml` is the orchestration layer. It detects changed repository areas and invokes reusable workflows with `needs` + `if`.

## Backend

`source -> tests -> security -> build -> Trivy -> SBOM -> ECR -> immutable digest -> same-monorepo GitOps PR`

## Web

`source -> npm test -> build -> immutable S3 release prefix -> index pointer -> CloudFront`

## Android

`android-vX.Y.Z tag -> tests -> signed AAB -> internal track -> protected production environment -> same AAB -> production track`

## Platform

GitHub Actions validates the Kubernetes/Argo tree. After merge, Argo CD reconciles it into EKS.

## Infrastructure

GitHub Actions runs Terraform formatting/validation/security/plan. Production apply is gated by the `production` environment.
