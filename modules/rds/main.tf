data "aws_subnet" "this" {
  id = var.rds_subnets[0]
}

data "aws_vpc" "this" {
  id = data.aws_subnet.this.vpc_id
}

data "aws_kms_key" "this" {
  key_id = "alias/aws/secretsmanager"
}

data "aws_secretsmanager_secret" "manager" {
  count = var.manage_master_user_password ? 1 : 0
  
  arn = try(aws_db_instance.this.master_user_secret[0].secret_arn, "")
}

data "aws_secretsmanager_secret_version" "manager" {
  count = var.manage_master_user_password ? 1 : 0
  
  secret_id = try(data.aws_secretsmanager_secret.manager[0].id, "")
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
  name   = "${var.identifier}-SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    {
      "Name" = "${var.identifier}-SG"
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

resource "aws_db_parameter_group" "this" {
  count = var.create_parameter_group ? 1 : 0

  name_prefix = "pg-${var.identifier}"
  family      = var.family

  dynamic "parameter" {
    for_each = var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }

  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_db_instance" "this" {
  identifier                          = var.identifier
  allocated_storage                   = var.size
  storage_encrypted                   = var.storage_encrypted
  storage_type                        = var.storage_type
  db_name                             = var.dbname
  engine                              = var.dbengine
  engine_version                      = var.dbengineversion
  instance_class                      = var.dbinstanceclass
  username                            = var.username
  manage_master_user_password         = var.manage_master_user_password ? var.manage_master_user_password : null
  password                            = var.manage_master_user_password == false || var.create_replica ? random_password.this[0].result : null
  db_subnet_group_name                = aws_db_subnet_group.this.id
  parameter_group_name                = var.create_parameter_group ? aws_db_parameter_group.this[0].name : "default.${var.family}"
  skip_final_snapshot                 = var.skip_final_snapshot
  publicly_accessible                 = var.publicly_accessible
  apply_immediately                   = var.apply_immediately
  vpc_security_group_ids              = [aws_security_group.this.id]
  maintenance_window                  = var.maintenance_window
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  performance_insights_enabled        = var.performance_insights_enabled
  deletion_protection                 = var.deletion_protection
  multi_az                            = var.multi_az
  replica_mode                        = var.replica_mode
  replicate_source_db                 = var.replicate_source_db
  iops                                = var.iops
  ca_cert_identifier                  = var.ca_cert_identifier
  port                                = var.port_db

  tags = merge(
    {
      "Name"     = var.identifier
      "Platform" = "RDS"
      "Type"     = "Database"
    },
    var.tags,
  )

}

resource "aws_db_subnet_group" "this" {
  name       = var.name_subnet_group
  subnet_ids = var.rds_subnets

  tags = {
    Name        = var.name_subnet_group
    Environment = var.environment
    Platform    = "rds"
    Type        = "group-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "replica" {
  count = var.create_replica ? 1 : 0

  replicate_source_db                 = aws_db_instance.this.identifier
  identifier                          = "${var.identifier}-replica"
  storage_encrypted                   = var.storage_encrypted
  storage_type                        = var.storage_type
  engine                              = var.dbengine
  engine_version                      = var.dbengineversion
  instance_class                      = var.dbinstanceclass
  password                            = random_password.this[0].result
  parameter_group_name                = var.create_parameter_group ? aws_db_parameter_group.this[0].name : "default.${var.family}"
  skip_final_snapshot                 = var.skip_final_snapshot
  publicly_accessible                 = var.publicly_accessible
  apply_immediately                   = var.apply_immediately
  vpc_security_group_ids              = [aws_security_group.this.id]
  maintenance_window                  = var.maintenance_window
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  performance_insights_enabled        = var.performance_insights_enabled
  deletion_protection                 = var.deletion_protection
  multi_az                            = var.multi_az
  replica_mode                        = var.replica_mode
  iops                                = var.iops
  ca_cert_identifier                  = var.ca_cert_identifier
  port                                = var.port_db

  tags = merge(
    {
      "Name"     = "${var.identifier}-replica"
      "Platform" = "RDS"
      "Type"     = "Database replica"
    },
    var.tags,
  )

}

resource "aws_secretsmanager_secret" "this" {
  count = var.manage_master_user_password == false || var.create_replica ? 1 : 0

  name_prefix = "database/${var.identifier}-"
  description = "Master account password on ${var.identifier}"
}

resource "aws_secretsmanager_secret_version" "this" {
  count = var.manage_master_user_password == false || var.create_replica ? 1 : 0

  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = jsonencode({
    username = var.username
    password = random_password.this[0].result
  })  
}

resource "random_password" "this" {
  count = var.manage_master_user_password == false || var.create_replica ? 1 : 0

  length           = 21
  special          = true
  override_special = "#$%&*_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  numeric          = true
}
