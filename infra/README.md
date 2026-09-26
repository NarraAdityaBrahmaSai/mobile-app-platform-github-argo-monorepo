# Infrastructure

Terraform for AWS and EKS. The stack is split into reusable modules and live environment roots.

## Roots

- `live/bootstrap` — one-time remote state foundation
- `live/prod` — production VPC, EKS, data, ECR, web delivery and GitHub OIDC roles

## Public repository safety

Do not commit `terraform.tfvars`. Start from `terraform.tfvars.example` and supply values through the protected GitHub environment or a local ignored file.

The example deliberately does not grant a default AdministratorAccess role. Supply your organization's approved least-privilege Terraform permission set.
