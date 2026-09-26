# Platform GitOps

This directory is the Kubernetes desired state for the monorepo. Argo CD reads `platform/argocd` and the environment trees below `platform/clusters`.

## Ownership

- `argocd/` — Argo CD Projects, Applications and bootstrap
- `clusters/prod/` — production workloads and platform addons
- `clusters/staging/` — staging-specific patches
- `clusters/dev/` — development-specific patches
- `policies/` — cluster/network security policies

## Deployment contract

Application CI never runs routine production `kubectl apply`. It publishes an immutable artifact and opens a GitOps pull request that changes the desired image digest here. Argo CD reconciles the merged state.
