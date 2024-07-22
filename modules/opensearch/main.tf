data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_security_group" "this" {
  count = var.vpc_enabled ? 1 : 0

  name        = "sgopensearch-${var.domain}"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr,
    ]
  }
}

resource "aws_opensearch_domain" "this" {
  domain_name    = var.domain
  engine_version = "OpenSearch_${var.cluster_version}"

  dynamic "cluster_config" {
    for_each = length(var.cluster_config) > 0 ? [var.cluster_config] : []
    content {
      instance_type            = try(cluster_config.value.instance_type, "t3.small.search")
      instance_count           = try(cluster_config.value.instance_count, 1)
      dedicated_master_enabled = try(cluster_config.value.dedicated_master_enabled, false)
      zone_awareness_enabled   = try(cluster_config.value.zone_awareness_enabled, false)
      dedicated_master_count   = try(cluster_config.value.dedicated_master_count, null)
      dedicated_master_type    = try(cluster_config.value.dedicated_master_type, "t3.small.search")

      dynamic "zone_awareness_config" {
        for_each = try(cluster_config.value.zone_awareness_config, [])
        content {
          availability_zone_count = try(zone_awareness_config.value.zone_awareness_config, 2)
        }
      }
    }

  }

  tags = merge(
    {
      "Name"     = format("%s-%s", var.domain, var.environment)
      "Platform" = "Opensearch"
      "Type"     = "Logs"
    },
    var.tags,
  )


  dynamic "vpc_options" {
    for_each = var.vpc_enabled ? [var.vpc_options] : []
    content {
      security_group_ids = concat(try(vpc_options.value.security_group_ids, []), aws_security_group.this[*].id)
      subnet_ids         = try(vpc_options.value.subnet_ids, [])
    }
  }

  advanced_security_options {
    enabled                        = var.security_advanced
    anonymous_auth_enabled         = var.anonymous_auth
    internal_user_database_enabled = var.internal_user
    master_user_options {
      master_user_name     = var.user
      master_user_password = random_password.this.result
    }
  }

  encrypt_at_rest {
    enabled = var.encrypt_at
  }

  domain_endpoint_options {
    custom_endpoint_enabled = var.endpoint
    custom_endpoint         = var.custom_endpoint
    enforce_https           = var.enforce_https
    tls_security_policy     = var.tls_security_policy
  }

  node_to_node_encryption {
    enabled = var.node_encryption
  }

  ebs_options {
    ebs_enabled = var.ebs
    volume_type = var.type
    volume_size = var.size
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "AUDIT_LOGS"
  }

}

resource "aws_cloudwatch_log_group" "this" {
  name = var.domain
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_name = var.domain

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_opensearch_domain_policy" "public" {
  count = var.public_enabled ? 1 : 0

  domain_name = aws_opensearch_domain.this.domain_name
  access_policies = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "es:*",
        "Principal" : "*",
        "Effect" : "Allow",
        "Resource" : "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*",
        "Condition" : {
          "IpAddress" : { "aws:SourceIp" : "${var.cidrs}" }
        }
      }
    ]
  })
}

resource "aws_opensearch_domain_policy" "vpc" {
  count = var.vpc_enabled ? 1 : 0

  domain_name     = aws_opensearch_domain.this.domain_name
  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
        }
    ]
}
CONFIG
}

resource "aws_secretsmanager_secret" "this" {
  name_prefix = "database/${var.domain}/master-"
  description = "Master account password on ${var.domain}"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = random_password.this.result
}

resource "random_password" "this" {
  length           = 21
  special          = true
  override_special = "#$%*+[]{}<>"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  numeric          = true
}
