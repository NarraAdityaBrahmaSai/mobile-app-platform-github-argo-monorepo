# Bootstrap Runbook

## 1. Prepare Terraform state

Run `infra/live/bootstrap`. Create the remote state foundation before using the production root.

## 2. Apply infrastructure

Configure `infra/live/prod/terraform.tfvars` locally or use the protected GitHub Terraform workflow. Supply approved least-privilege IAM policy ARNs; the public example intentionally does not default to AdministratorAccess.

## 3. Configure GitHub

Create the repository, protect `main`, create the required environments, configure repository/environment variables and create the deployment GitHub App.

## 4. Install private runner

Install a self-hosted GitHub runner inside the VPC with label `aws-private`.

## 5. Bootstrap Argo CD

Manually run `.github/workflows/bootstrap.yml` using the `production-bootstrap` environment. It installs Argo CD and applies the root Application that points at this monorepo.

## 6. First application release

Merge application code. The main dispatcher identifies the changed area, invokes security plus the relevant pipeline, builds/publishes the artifact, and—when applicable—opens the GitOps promotion PR.
