data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  count = var.proxy_create ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "this" {
  count = var.proxy_create ? 1 : 0

  # secretsmanager
  statement {
    sid = "GetSecretValue"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      var.manage_master_user_password ? "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${data.aws_secretsmanager_secret.manager[0].name}" : "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${aws_secretsmanager_secret.this[0].name}"
    ]
  }

  # kms
  statement {
    sid = "DecryptSecretValue"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
        var.manage_master_user_password ? "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${data.aws_secretsmanager_secret.manager[0].name}" : "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${aws_secretsmanager_secret.this[0].name}"
    ]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"

      values = [
        "secretsmanager.${data.aws_region.current.name}.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.proxy_create ? 1 : 0

  name_prefix = "role-proxy-"

  tags = merge(
    {
      "Name"     = "role-proxy"
      "Platform" = "IAM"
      "Type"     = "role"
    },
    var.tags,
  )

  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "this" {
  count = var.proxy_create ? 1 : 0

  name_prefix = "rds-proxy-policy-"
  role        = aws_iam_role.this[0].id
  policy      = data.aws_iam_policy_document.this[0].json
}

resource "aws_db_proxy" "this" {
  count = var.proxy_create ? 1 : 0

  name                   = format("%s-proxy", var.identifier)
  debug_logging          = false
  engine_family          = var.engine_family
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = aws_iam_role.this[0].arn
  vpc_security_group_ids = [aws_security_group.this.id]
  vpc_subnet_ids         = var.rds_subnets

  auth {
    auth_scheme = "SECRETS"
    description = "SecretsManager"
    iam_auth    = "DISABLED"
    secret_arn  = var.manage_master_user_password ? "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${data.aws_secretsmanager_secret.manager[0].name}" : "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${aws_secretsmanager_secret.this[0].name}"
  }

  tags = merge(
    {
      "Name"     = format("%s-proxy", var.identifier)
      "Platform" = "RDS"
      "Type"     = "Proxy"
    },
    var.tags,
  )
}

resource "aws_db_proxy_target" "this" {
  count = var.proxy_create ? 1 : 0

  db_instance_identifier = aws_db_instance.this.identifier
  db_proxy_name          = aws_db_proxy.this[0].name
  target_group_name      = aws_db_proxy_default_target_group.this[0].name
}

resource "aws_db_proxy_default_target_group" "this" {
  count = var.proxy_create ? 1 : 0

  db_proxy_name = aws_db_proxy.this[0].name

  dynamic "connection_pool_config" {
    for_each = var.connection_pool_config
    content {
      connection_borrow_timeout    = lookup(connection_pool_config.value, "connection_borrow_timeout", null)
      init_query                   = lookup(connection_pool_config.value, "init_query", "")
      max_connections_percent      = lookup(connection_pool_config.value, "max_connections_percent", null)
      max_idle_connections_percent = lookup(connection_pool_config.value, "max_idle_connections_percent", null)
      session_pinning_filters      = lookup(connection_pool_config.value, "session_pinning_filters", [])
    }
  }
}
