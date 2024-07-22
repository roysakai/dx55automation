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
        from_port   = "${var.port_db}"
        to_port     = "${var.port_db}"
        type        = "ingress"
        cidr_blocks = [data.aws_vpc.this.cidr_block]
      }
    },
    var.additional_rules_security_group,
  )
}

resource "aws_security_group" "this" {
  vpc_id = data.aws_subnet.this.vpc_id
  name   = "${var.broker_name}-SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    {
      "Name" = "${var.broker_name}-SG"
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

resource "aws_mq_broker" "this" {
  broker_name = var.broker_name

  dynamic "configuration" {
    for_each = var.configuration
    content {
      id       = lookup(configuration.value, "id", "")
      revision = lookup(configuration.value, "revision", "")
    }
  }

  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type
  security_groups            = [aws_security_group.this.id]
  subnet_ids                 = var.subnet_ids
  deployment_mode            = var.deployment_mode
  publicly_accessible        = var.publicly_accessible
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  storage_type               = var.storage_type

  dynamic "maintenance_window_start_time" {
    for_each = var.maintenance_window_start_time
    content {
      day_of_week = lookup(maintenance_window_start_time.value, "day_of_week", "SUNDAY")
      time_of_day = lookup(maintenance_window_start_time.value, "time_of_day", "02:00")
      time_zone   = lookup(maintenance_window_start_time.value, "timezone", "UTC")
    }
  }

  dynamic "logs" {
    for_each = var.logs
    content {
      audit   = lookup(logs.value, "audit", false)
      general = lookup(logs.value, "general", false)
    }
  }

  user {
    username = var.username
    password = random_password.this.result
  }

  tags = merge(
    {
      "Name"     = var.broker_name
      "Platform" = "MQ"
      "Type"     = "Broker"
    },
    var.tags,
  )
}

resource "aws_secretsmanager_secret" "this" {

  name_prefix = "database/${var.broker_name}-"
  description = "Master account password on ${var.broker_name}"
}

resource "aws_secretsmanager_secret_version" "this" {

  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = var.username
    password = random_password.this.result
  })
}

resource "random_password" "this" {
  length           = 21
  special          = true
  override_special = "#$%&*"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  numeric          = true
}
