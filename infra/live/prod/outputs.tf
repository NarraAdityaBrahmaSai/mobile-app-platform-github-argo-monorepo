output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "backend_ecr_repository_url" {
  value = module.ecr_backend.repository_url
}

output "web_bucket_name" {
  value = module.web.bucket_name
}

output "cloudfront_distribution_id" {
  value = module.web.distribution_id
}

output "cloudfront_domain_name" {
  value = module.web.distribution_domain_name
}


output "database_endpoint" {
  value = module.data.database_endpoint
}

output "redis_primary_endpoint" {
  value = module.data.redis_primary_endpoint
}

output "application_secret_arn" {
  value = module.data.secret_arn
}

output "github_ecr_publish_role_arn" { value = module.github_app_ecr_oidc.role_arn }
output "github_web_publish_role_arn" { value = module.github_app_web_oidc.role_arn }
output "github_infra_role_arn" { value = module.github_infra_oidc.role_arn }
output "github_argocd_bootstrap_role_arn" { value = module.github_platform_bootstrap_oidc.role_arn }
