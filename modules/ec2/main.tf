resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh

  tags = merge(
    {
      "Name" = "${var.name}-key-pair"
    },
    var.tags
  )
}

resource "aws_instance" "this" {
  ami                         = var.use_data ? data.aws_ami.img[0].id : var.ami
  instance_type               = var.instance_type
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = aws_key_pair.this.key_name
  user_data_replace_on_change = var.user_data_replace_on_change
  monitoring                  = var.monitoring
  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip

  ebs_optimized = var.ebs_optimized

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = var.encrypted == true ? aws_kms_key.this[0].key_id : null
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = var.encrypted == true ? aws_kms_key.this[0].key_id : null
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  provisioner "local-exec" {
    command = "echo '${tls_private_key.this.private_key_pem}' > ${var.key_name}.pem"
  }

  disable_api_termination = var.disable_api_termination

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  tags = merge(
    {
      "Name"     = var.name
      "Platform" = "EC2"
      "Type"     = "Machine"
    },
    var.tags
  )
  volume_tags = merge(
    { "Name" = "${var.name}-volume" },
    var.volume_tags,
    var.tags
  )
}

resource "aws_security_group" "this" {
  vpc_id      = data.aws_subnet.this.vpc_id
  name_prefix = "${var.name}-SG-"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    {
      "Name" = "${var.name}-SG"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "this" {

  for_each                 = var.security_group_rules
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

resource "aws_iam_role" "this" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    {
      "Name" = "${var.name}-role"
    },
    var.tags
  )
}


resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(
    ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
      "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  ])
  role       = aws_iam_role.this.name
  policy_arn = each.key
}

resource "aws_iam_instance_profile" "this" {
  role = aws_iam_role.this.name

  tags = merge(
    {
      "Name" = "${var.name}-profile"
    },
    var.tags
  )
}

resource "aws_iam_role_policy" "this" {
  for_each = var.additional_policy ? { for x in var.policy_additional : x.name => x } : {}

  name   = each.value.name
  role   = aws_iam_role.this.id
  policy = each.value.policy
}

resource "aws_eip" "this" {
  count    = var.eip ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"

  tags = merge(
    {
      "Name" = "${var.name}-eip"
    },
    var.tags
  )
}

resource "aws_kms_key" "this" {
  count       = var.encrypted ? 1 : 0
  description = "KMS key EC2 ${var.name}"

  tags = merge(
    {
      "Name" = "${var.name}-kms"
    },
    var.tags
  )
}

resource "aws_kms_alias" "this" {
  count         = var.encrypted ? 1 : 0
  name          = "alias/ec2/${var.name}"
  target_key_id = aws_kms_key.this[count.index].key_id
}
