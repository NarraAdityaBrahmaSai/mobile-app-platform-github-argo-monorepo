
variable "github_org" { type = string }
variable "github_repo" { type = string }
variable "role_name" { type = string }
variable "allowed_subjects" { type = list(string) }
variable "policy_arns" { type = list(string) }
variable "oidc_provider_arn" { type = string }

data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals { type = "Federated" identifiers = [var.oidc_provider_arn] }
    condition { test = "StringEquals" variable = "token.actions.githubusercontent.com:aud" values = ["sts.amazonaws.com"] }
    condition { test = "StringLike" variable = "token.actions.githubusercontent.com:sub" values = var.allowed_subjects }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}
resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}
output "role_arn" { value = aws_iam_role.this.arn }
