variable "name" { type = string }
variable "vpc_id" { type = string }
variable "database_subnet_ids" { type = list(string) }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "redis_subnet_ids" { type = list(string) }
variable "redis_node_type" { type = string }
variable "application_security_group_id" { type = string }
variable "application_secret_name" { type = string }

resource "aws_security_group" "database" {
  name        = "${var.name}-database"
  description = "Database security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "redis" {
  name        = "${var.name}-redis"
  description = "Redis security group"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "database_from_application" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = var.application_security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "redis_from_application" {
  security_group_id            = aws_security_group.redis.id
  referenced_security_group_id = var.application_security_group_id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.name}-aurora"
  subnet_ids = var.database_subnet_ids
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "${var.name}-aurora"
  engine             = "aurora-postgresql"
  engine_version     = var.engine_version
  database_name      = "platform"
  master_username    = "platform_admin"

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.database.id]

  storage_encrypted               = true
  backup_retention_period         = 14
  preferred_backup_window         = "18:00-19:00"
  preferred_maintenance_window    = "sun:19:00-sun:20:00"
  deletion_protection             = true
  copy_tags_to_snapshot            = true
  skip_final_snapshot              = false
  final_snapshot_identifier_prefix = "${var.name}-final"

  enabled_cloudwatch_logs_exports = ["postgresql"]
}

resource "aws_rds_cluster_instance" "aurora" {
  count              = 2
  identifier         = "${var.name}-aurora-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version
  publicly_accessible = false
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.name}-redis"
  subnet_ids = var.redis_subnet_ids
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "${var.name}-redis"
  description                = "Redis for ${var.name}"
  node_type                  = var.redis_node_type
  port                       = 6379
  parameter_group_name       = "default.redis7"
  engine                     = "redis"
  engine_version             = "7.1"
  num_cache_clusters         = 2
  automatic_failover_enabled = true
  multi_az_enabled           = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.redis.name
  security_group_ids         = [aws_security_group.redis.id]
}

resource "aws_secretsmanager_secret" "application" {
  name                    = var.application_secret_name
  recovery_window_in_days = 7
}

output "database_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "database_reader_endpoint" {
  value = aws_rds_cluster.aurora.reader_endpoint
}

output "redis_primary_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "secret_arn" {
  value = aws_secretsmanager_secret.application.arn
}

output "database_security_group_id" {
  value = aws_security_group.database.id
}

output "redis_security_group_id" {
  value = aws_security_group.redis.id
}
