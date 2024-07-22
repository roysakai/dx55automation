data "aws_subnet" "this" {
  id = var.subnet_ids[0]
}

data "aws_vpc" "this" {
  id = data.aws_subnet.this.vpc_id
}

locals {
  ingress_with_source_security_group = merge(
    {
      ingress_rule = {
        description = "Access db"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        type        = "ingress"
        self        = true
      }
      ingress_db = {
        description = "Access db vpc"
        protocol    = "tcp"
        from_port   = "${var.redis-port}"
        to_port     = "${var.redis-port}"
        type        = "ingress"
        cidr_blocks = [data.aws_vpc.this.cidr_block]
      }
    },
    var.additional_rules_security_group,
  )
}

resource "aws_security_group" "this" {
  vpc_id = data.aws_subnet.this.vpc_id
  name   = "${var.redis-name}-SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    {
      "Name" = "${var.redis-name}-SG"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "this" {

  for_each                 = local.ingress_with_source_security_group
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  type                     = each.value.type
  security_group_id        = aws_security_group.this.id
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  description              = lookup(each.value, "description", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_parameter_group" "this" {
  count = var.create_parameter_group ? 1 : 0

  name   = format("%s-pg", var.redis-name)
  family = var.family

  dynamic "parameter" {
    for_each = var.num_node_groups != null ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }

  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_elasticache_subnet_group" "this" {
  name       = format("%s-subnet-group", var.redis-name)
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "redis_replication" {

  replication_group_id       = var.redis-name
  description                = var.description
  node_type                  = var.redis-instance-type != "" ? var.redis-instance-type : "cache.t2.micro"
  num_cache_clusters         = var.redis-instance-number != null ? var.redis-instance-number : null
  auth_token                 = random_password.this.result
  engine_version             = var.redis-engine-version
  parameter_group_name       = var.create_parameter_group ? aws_elasticache_parameter_group.this[0].name : "default.${var.family}"
  transit_encryption_enabled = var.tls
  port                       = var.redis-port != "" ? var.redis-port : "6379"
  automatic_failover_enabled = var.automatic-failover-enabled
  maintenance_window         = var.maintenance_window
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  multi_az_enabled           = var.multi_az_enabled
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  at_rest_encryption_enabled = var.at_rest_encryption_enabled


  num_node_groups         = var.cluster_mode_enabled == true && var.num_node_groups != null ? var.num_node_groups : null
  replicas_per_node_group = var.cluster_mode_enabled == true && var.replicas_per_node_group != null ? var.replicas_per_node_group : null

  apply_immediately = var.apply_immediately

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]

  tags = {
    Name        = var.redis-name
    Environment = var.environment
    Platform    = "redis"
    Type        = "service"
  }

}

resource "aws_secretsmanager_secret" "this" {
  name_prefix = "database/${var.redis-name}-"
  description = "Master account password on ${var.redis-name}"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = var.username
    password = random_password.this.result
  })  
}

resource "random_password" "this" {
  length           = 21
  special          = false
  override_special = "#$%&*_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 0
  numeric          = true
}
