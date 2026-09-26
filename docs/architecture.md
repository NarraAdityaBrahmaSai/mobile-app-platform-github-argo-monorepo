# Architecture

## System architecture

```mermaid
flowchart LR
  Dev[Developer] --> GH[GitHub Monorepo]
  GH --> Main[Main Pipeline]
  Main --> Sec[Security Pipeline]
  Main --> BE[Backend Pipeline]
  Main --> WEB[Web Pipeline]
  Main --> AND[Android Pipeline]
  Main --> TF[Infrastructure Pipeline]
  Main --> PLAT[Platform Pipeline]

  BE --> ECR[(Amazon ECR)]
  WEB --> S3[(Private S3)]
  S3 --> CF[CloudFront]
  BE --> PR[GitOps Pull Request]
  PR --> Git[platform/ desired state]
  Git --> Argo[Argo CD]
  Argo --> EKS[Amazon EKS]
  EKS --> DB[(Aurora PostgreSQL)]
  EKS --> Redis[(ElastiCache Redis)]
  EKS --> Obs[Metrics / Logs / Traces]
  AND --> Play[Google Play]
```

## Main pipeline decision model

```mermaid
flowchart TD
  Start[PR / Push / Android Tag / Manual] --> Detect[Detect changed areas]
  Detect --> Security{Security required?}
  Security -->|yes| S[Security Pipeline]
  Security -->|no| SkipS[Skip Security]
  S --> Router{Which areas changed?}
  SkipS --> Router
  Router -->|backend| B[Backend Pipeline]
  Router -->|web| W[Web Pipeline]
  Router -->|android| A[Android Pipeline]
  Router -->|infra| I[Terraform Pipeline]
  Router -->|platform| P[Argo/Kubernetes Validation]
```

## Production backend delivery

```mermaid
sequenceDiagram
  participant D as Developer
  participant G as GitHub
  participant A as Actions
  participant E as ECR
  participant PR as GitOps PR
  participant AC as Argo CD
  participant K as EKS

  D->>G: Merge application code
  G->>A: Main pipeline
  A->>A: Tests + security
  A->>E: Push immutable image tag
  A->>E: Resolve sha256 digest
  A->>PR: Open PR changing Kustomize digest
  PR->>G: Review + merge
  G->>AC: Git desired state changes
  AC->>K: Reconcile
  K-->>AC: Health status
```

## Repository layout

```text
.
├── .github/
│   ├── workflows/            # main dispatcher + reusable workflows
│   ├── CODEOWNERS
│   └── dependabot.yml
├── app/
│   ├── backend/              # Python API + Dockerfile + tests
│   ├── web/                  # static frontend
│   └── android/              # Android + Fastlane
├── infra/
│   ├── live/bootstrap/       # Terraform state bootstrap
│   ├── live/prod/            # production root
│   └── modules/               # reusable AWS modules
├── platform/
│   ├── argocd/                # Argo CD Projects/Applications/bootstrap
│   └── clusters/              # desired Kubernetes state
├── docs/
└── scripts/
```
