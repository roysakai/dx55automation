# ## EC2 rabbit
module "secret-manager" {
  source = "./modules/secret-manager"

  count = local.create_rabbit_ec2 ? 1 : 0

  name     = "rabbit"
  username = "admin"
}

module "ec2-rabbit" {
  source = "./modules/ec2"

  count = local.create_rabbit_ec2 ? 1 : 0

  name                        = local.rabbit_1
  instance_type               = local.type_instance_rabbit
  associate_public_ip_address = false
  key_name                    = local.key_rabbit_1
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
  user_data_replace_on_change = false

  user_data = templatefile("userdata_rabbit.sh", {
    bucket_name  = module.s3[0].bucket-name
    key_rabbit_1 = module.ec2-rabbit[0].key
    key_rabbit_2 = module.ec2-rabbit-2[0].key
    key_rabbit_3 = module.ec2-rabbit-3[0].key
    user         = local.user_ec2_rabbit
    password     = module.secret-manager[0].secret_string_custom
    rabbit_1     = local.rabbit_1
    rabbit_2     = local.rabbit_2
    rabbit_3     = local.rabbit_3
  })

  security_group_rules = {
    ingress_rule_1 = {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = [module.vpc.vpc_cidr]
      type        = "ingress"
      description = "SSH"
    }
    ingress_rule_2 = {
      from_port                = 15672
      to_port                  = 15672
      protocol                 = "tcp"
      source_security_group_id = module.nlb[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    ingress_rule_3 = {
      from_port                = 5672
      to_port                  = 5672
      protocol                 = "tcp"
      source_security_group_id = module.nlb[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    # Add more rules as needed
  }

  additional_policy = true

  policy_additional = [
    {
      name = "policy-acs-s3"
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect = "Allow",
            Action = [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject",
              "s3:ListMultipartUploadParts",
              "s3:AbortMultipartUpload",
            ],
            Resource = [
              "${module.s3[0].bucket-arn}/*"
            ],
          },
        ],
      })
    }
  ]

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.volume_size_rabbit
      tags = {
        Name = "root-block"
      }
    },
  ]

  tags = merge(
    {
      Environment = local.environment
    },
    local.tags
  )

  depends_on = [
    module.ec2-rabbit-2[0],
    module.ec2-rabbit-3[0]
  ]
}

module "ec2-rabbit-2" {
  source = "./modules/ec2"

  count = local.create_rabbit_ec2 ? 1 : 0

  name                        = local.rabbit_2
  instance_type               = local.type_instance_rabbit_2
  associate_public_ip_address = false
  key_name                    = local.rabbit_2
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
  user_data_replace_on_change = false
  user_data                   = file("userdata-ssm.sh")

  security_group_rules = {
    ingress_rule_1 = {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = [module.vpc.vpc_cidr]
      type        = "ingress"
      description = "SSH"
    }
    ingress_rule_2 = {
      from_port                = 15672
      to_port                  = 15672
      protocol                 = "tcp"
      source_security_group_id = module.nlb[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    ingress_rule_3 = {
      from_port                = 5672
      to_port                  = 5672
      protocol                 = "tcp"
      source_security_group_id = module.nlb[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    # Add more rules as needed
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.volume_size_rabbit_2
      tags = {
        Name = "root-block"
      }
    },
  ]

  tags = merge(
    {
      Environment = local.environment
    },
    local.tags
  )
}

module "ec2-rabbit-3" {
  source = "./modules/ec2"

  count = local.create_rabbit_ec2 ? 1 : 0

  name                        = local.rabbit_3
  instance_type               = local.type_instance_rabbit_3
  associate_public_ip_address = false
  key_name                    = local.key_rabbit_3
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
  user_data_replace_on_change = false
  user_data                   = file("userdata-ssm.sh")

  security_group_rules = {
    ingress_rule_1 = {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = [module.vpc.vpc_cidr]
      type        = "ingress"
      description = "SSH"
    }
    ingress_rule_2 = {
      from_port                = 15672
      to_port                  = 15672
      protocol                 = "tcp"
      source_security_group_id = module.nlb[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    ingress_rule_3 = {
      from_port                = 5672
      to_port                  = 5672
      protocol                 = "tcp"
      source_security_group_id = module.nlb[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    # Add more rules as needed
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.volume_size_rabbit_3
      tags = {
        Name = "root-block"
      }
    },
  ]

  tags = merge(
    {
      Environment = local.environment
    },
    local.tags
  )
}

module "nlb" {
  source = "terraform-aws-modules/alb/aws"

  count = local.create_rabbit_ec2 ? 1 : 0

  name                       = local.nlb_rabbit
  load_balancer_type         = "network"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = local.private_subnets_nlb
  internal                   = local.internal
  enable_deletion_protection = false

  # Security Group
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  security_group_ingress_rules = {
    all_http = {
      from_port   = 15672
      to_port     = 15672
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    p_http = {
      from_port   = 5672
      to_port     = 5672
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 448
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = local.listeners_rabbit

  target_groups = {
    rabbit-target-http = {
      name_prefix = "rb1-"
      protocol    = "TCP"
      port        = 15672
      target_type = "instance"
      target_id   = module.ec2-rabbit[0].id
    }
    rabbit-target-api = {
      name_prefix = "api-"
      protocol    = "TCP"
      port        = 5672
      target_type = "instance"
      target_id   = module.ec2-rabbit[0].id
    }
  }

  tags = {
    Environment = local.environment
  }
}
