# Publish to a Public GitHub Repository

## Recommended repository

```text
mobile-platform-github-argo
```

## Before pushing

```bash
./scripts/check-public-repo.sh
./scripts/validate-repository.sh
```

Review placeholders such as `<GITHUB_OWNER>`, `<ACCOUNT_ID>`, certificate IDs and domain names. Replace them only with public-safe values where the repository should contain examples; keep real secrets and private infrastructure identifiers in GitHub/AWS configuration.

## Publish with GitHub CLI

```bash
gh auth login
export GITHUB_OWNER='<your-user-or-org>'
export GITHUB_REPOSITORY_NAME='mobile-platform-github-argo'
./scripts/publish-public.sh
```

The helper creates the repository as public when it does not already exist, initializes/preserves `main`, commits the monorepo, configures `origin`, and pushes the repository.

## Repository settings after publishing

1. Protect `main`.
2. Require pull requests and required checks appropriate for the project.
3. Create `production`, `production-bootstrap`, `android-internal`, and `android-production` environments.
4. Add required reviewers to production environments.
5. Configure repository/environment variables documented in `docs/github-actions-configuration.md`.
6. Create the deployment GitHub App and install it only on this repository.
7. Configure AWS OIDC roles from `infra/live/prod`.
8. Install the VPC-connected runner with label `aws-private` before running Argo bootstrap.
