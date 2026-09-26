# Public Repository Publishing Guide

## What can be public

This repository contains architecture, source code, infrastructure definitions, Kubernetes desired state and CI/CD configuration. Account-specific IDs, DNS names, certificates, credentials and secrets are placeholders or GitHub/AWS configuration items.

## Before publishing

Run:

```bash
./scripts/check-public-repo.sh
./scripts/validate-repository.sh
```

Then review `grep -R` results for your own organization-specific values.

## Publish with GitHub CLI

```bash
export GITHUB_OWNER='<your-user-or-organization>'
export GITHUB_REPOSITORY_NAME='mobile-platform-github-argo'
./scripts/publish-public.sh
```

The helper creates the repository as public if it does not already exist, adds `origin`, commits the source tree and pushes `main`.
