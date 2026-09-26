# GitHub Actions Configuration

This monorepo uses one GitHub repository and one set of workflows. There are no separate application/platform/infrastructure repositories.

## Required Environments

Create these GitHub Environments:

### `production`

Use required reviewers for production jobs. Variables/secrets commonly used by production jobs:

- `AWS_WEB_PUBLISH_ROLE_ARN`
- `WEB_BUCKET`
- `CLOUDFRONT_DISTRIBUTION_ID`
- `GITOPS_APP_ID`
- secret `GITOPS_APP_PRIVATE_KEY`

`production` is used by web publication, GitOps promotion and Terraform apply.

### `android-internal`

- `PLAY_PACKAGE_NAME` variable
- `ANDROID_KEYSTORE_B64` secret
- `ANDROID_KEYSTORE_PASSWORD` secret
- `ANDROID_KEY_ALIAS` secret
- `ANDROID_KEY_PASSWORD` secret
- `GOOGLE_PLAY_JSON` secret

### `android-production`

- `PLAY_PACKAGE_NAME` variable
- `PLAY_ROLLOUT_FRACTION` variable
- `GOOGLE_PLAY_JSON` secret

Add required reviewers if production Google Play promotion is subject to a release approval process.

### `production-bootstrap`

- `AWS_ARGOCD_BOOTSTRAP_ROLE_ARN`
- `EKS_CLUSTER_NAME`
- `AWS_REGION`

## Repository-level variables

These are needed by workflows that run before an environment gate or are shared across environments:

- `AWS_REGION`
- `AWS_INFRA_ROLE_ARN`
- `AWS_ECR_PUBLISH_ROLE_ARN`
- `TF_PROJECT_NAME`
- `TF_ENVIRONMENT`
- `TF_AZS_JSON`
- `TF_EKS_VERSION`
- `TF_PLATFORM_ADMIN_ROLE_ARN`
- `TF_DOMAIN_NAME`
- `TF_WEB_BUCKET_NAME`
- `TF_CLOUDFRONT_CERTIFICATE_ARN`
- `TF_GITHUB_INFRA_POLICY_ARNS_JSON`

## GitHub App

Create a deployment-only GitHub App installed on this repository. The app should have only the repository permissions needed to create a branch and pull request for the GitOps promotion. The backend workflow creates a short-lived installation token at runtime.

Using an App token rather than `GITHUB_TOKEN` for the GitOps PR avoids depending on the workflow-recursion behavior of `GITHUB_TOKEN`.

## AWS OIDC

Configure IAM to trust `https://token.actions.githubusercontent.com` with audience `sts.amazonaws.com`. Restrict each role's `sub` claim to the exact monorepo branch/environment subjects used by that role.

## Security

Never store AWS access keys in GitHub. Use OIDC and short-lived sessions. Keep signing keys and Play credentials in protected environment secrets.
