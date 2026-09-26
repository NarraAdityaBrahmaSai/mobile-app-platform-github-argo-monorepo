module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = "${var.project_name}-${var.environment}"
  cidr = var.vpc_cidr

  azs = var.azs

  private_subnets = [
    "10.20.11.0/24",
    "10.20.12.0/24",
    "10.20.13.0/24",
  ]

  public_subnets = [
    "10.20.1.0/24",
    "10.20.2.0/24",
    "10.20.3.0/24",
  ]

  database_subnets = [
    "10.20.21.0/24",
    "10.20.22.0/24",
    "10.20.23.0/24",
  ]

  enable_nat_gateway = true
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.26.0"

  name               = "${var.project_name}-${var.environment}"
  kubernetes_version = var.eks_version

  endpoint_public_access  = false
  endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    general = {
      instance_types = var.node_instance_types
      min_size       = var.node_min
      max_size       = var.node_max
      desired_size   = var.node_min

      labels = {
        workload = "general"
      }

      update_config = {
        max_unavailable_percentage = 33
      }
    }
  }

  access_entries = {
    platform_admin = {
      principal_arn = var.platform_admin_role_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}

module "ecr_backend" {
  source = "../../modules/ecr"
  name   = "${var.project_name}/backend"
}

module "web" {
  source = "../../modules/web"

  bucket_name     = var.web_bucket_name
  domain_name     = var.domain_name
  certificate_arn = var.cloudfront_certificate_arn
}


module "data" {
  source = "../../modules/data"

  name               = "${var.project_name}-${var.environment}"
  vpc_id             = module.vpc.vpc_id
  database_subnet_ids = module.vpc.database_subnets
  engine_version     = var.aurora_engine_version
  instance_class     = var.aurora_instance_class
  redis_subnet_ids   = module.vpc.private_subnets
  redis_node_type    = var.redis_node_type
  application_security_group_id = module.eks.node_security_group_id
  application_secret_name = "/prod/mobile-platform/backend"
}


resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

module "github_infra_oidc" {
  source = "../../modules/github-oidc"
  github_org = var.github_org
  github_repo = var.github_repo
  role_name = "${var.project_name}-github-infra"
  allowed_subjects = [
    "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main",
    "repo:${var.github_org}/${var.github_repo}:environment:production"
  ]
  policy_arns = var.github_infra_policy_arns
  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
}

module "github_platform_bootstrap_oidc" {
  source = "../../modules/github-oidc"
  github_org = var.github_org
  github_repo = var.github_repo
  role_name = "${var.project_name}-github-platform-bootstrap"
  allowed_subjects = ["repo:${var.github_org}/${var.github_repo}:environment:production-bootstrap"]
  policy_arns = var.github_infra_policy_arns
  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
}

data "aws_iam_policy_document" "app_ecr_publish" {
  statement {
    effect = "Allow"
    actions = ["ecr:BatchCheckLayerAvailability","ecr:CompleteLayerUpload","ecr:InitiateLayerUpload","ecr:PutImage","ecr:UploadLayerPart","ecr:BatchGetImage","ecr:DescribeImages"]
    resources = [module.ecr_backend.repository_arn]
  }
  statement { effect = "Allow" actions = ["ecr:GetAuthorizationToken"] resources = ["*"] }
}
resource "aws_iam_policy" "app_ecr_publish" { name = "${var.project_name}-app-ecr-publish" policy = data.aws_iam_policy_document.app_ecr_publish.json }
module "github_app_ecr_oidc" {
  source = "../../modules/github-oidc"
  github_org = var.github_org
  github_repo = var.github_repo
  role_name = "${var.project_name}-github-app-ecr"
  allowed_subjects = ["repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"]
  policy_arns = [aws_iam_policy.app_ecr_publish.arn]
  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
}

data "aws_iam_policy_document" "app_web_publish" {
  statement { effect = "Allow" actions = ["s3:ListBucket"] resources = [module.web.bucket_arn] }
  statement { effect = "Allow" actions = ["s3:PutObject","s3:DeleteObject"] resources = ["${module.web.bucket_arn}/releases/*","${module.web.bucket_arn}/index.html"] }
  statement { effect = "Allow" actions = ["cloudfront:CreateInvalidation"] resources = ["*"] }
}
resource "aws_iam_policy" "app_web_publish" { name = "${var.project_name}-app-web-publish" policy = data.aws_iam_policy_document.app_web_publish.json }
module "github_app_web_oidc" {
  source = "../../modules/github-oidc"
  github_org = var.github_org
  github_repo = var.github_repo
  role_name = "${var.project_name}-github-app-web"
  allowed_subjects = ["repo:${var.github_org}/${var.github_repo}:environment:production"]
  policy_arns = [aws_iam_policy.app_web_publish.arn]
  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
}
