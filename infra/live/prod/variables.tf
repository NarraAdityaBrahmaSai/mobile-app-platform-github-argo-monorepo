variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "mobile-platform"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "azs" {
  type = list(string)
}

variable "eks_version" {
  type = string
}

variable "node_instance_types" {
  type    = list(string)
  default = ["m7i.large"]
}

variable "node_min" {
  type    = number
  default = 3
}

variable "node_max" {
  type    = number
  default = 12
}

variable "platform_admin_role_arn" {
  type        = string
  description = "Existing break-glass/platform administrator role."
}





variable "domain_name" {
  type        = string
  description = "Public web/API domain."
}

variable "web_bucket_name" {
  type        = string
  description = "Globally unique private S3 bucket for web assets."
}

variable "cloudfront_certificate_arn" {
  type        = string
  description = "ACM certificate ARN in us-east-1 for CloudFront."
}

variable "aurora_engine_version" {
  type = string
  default = "17.5"
}
variable "aurora_instance_class" {
  type = string
  default = "db.r7g.large"
}
variable "redis_node_type" {
  type = string
  default = "cache.r7g.large"
}

variable "github_org" {
  type = string
}

variable "github_repo" {
  type    = string
  default = "mobile-platform-github-argo"
}

variable "github_infra_policy_arns" {
  type        = list(string)
  description = "Approved least-privilege managed IAM policy ARNs for Terraform."
}
