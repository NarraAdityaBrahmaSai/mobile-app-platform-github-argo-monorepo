
# AWS IAM model

GitHub Actions authenticates through GitHub OIDC. Trust policies should restrict the `sub` claim to the exact repository and branch/environment. GitHub's AWS guidance uses `token.actions.githubusercontent.com` and `sts.amazonaws.com`. citeturn0search0

Roles in this reference:

- Terraform infrastructure role
- application ECR publish role
- web publish role
- Argo CD bootstrap role

The public Terraform example does not assign a default managed policy. Supply your organization-approved least-privilege Terraform policy set through `TF_GITHUB_INFRA_POLICY_ARNS_JSON`; keep broad bootstrap permissions outside the public repository and time-bound them.

EKS workloads should use EKS Pod Identity for AWS APIs. AWS documents the `pods.eks.amazonaws.com` trust principal and service-account association model. citeturn0search3turn0search7
