# ## EC2 elastic
module "ec2-elastic" {
  source = "./modules/ec2"

  count = local.create_elastic_ec2 ? 1 : 0

  name                        = local.elastic_1
  instance_type               = local.type_instance_elastic
  associate_public_ip_address = false
  key_name                    = local.key_elastic_1
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
  user_data_replace_on_change = false

  user_data = templatefile("userdata_elasticsearch.sh", {
    bucket_name     = module.s3-elastic[0].bucket-name
    key_elastic_1   = module.ec2-elastic[0].key
    key_elastic_2   = module.ec2-elastic-2[0].key
    key_elastic_3   = module.ec2-elastic-3[0].key
    user            = local.user_ec2_elastic
    elastic_1       = local.elastic_1
    elastic_2       = local.elastic_2
    elastic_3       = local.elastic_3
    version_elastic = local.version_elastic
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
      from_port                = 9200
      to_port                  = 9200
      protocol                 = "tcp"
      source_security_group_id = module.nlb-elastic[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    ingress_rule_3 = {
      from_port                = 5601
      to_port                  = 5601
      protocol                 = "tcp"
      source_security_group_id = module.nlb-elastic[0].security_group_id
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
              "${module.s3-elastic[0].bucket-arn}/*"
            ],
          },
        ],
      })
    }
  ]

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.volume_size_elastic
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
    module.ec2-elastic-2[0],
    module.ec2-elastic-3[0]
  ]
}

module "ec2-elastic-2" {
  source = "./modules/ec2"

  count = local.create_elastic_ec2 ? 1 : 0

  name                        = local.elastic_2
  instance_type               = local.type_instance_elastic_2
  associate_public_ip_address = false
  key_name                    = local.elastic_2
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
      from_port                = 9200
      to_port                  = 9200
      protocol                 = "tcp"
      source_security_group_id = module.nlb-elastic[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    ingress_rule_3 = {
      from_port                = 5601
      to_port                  = 5601
      protocol                 = "tcp"
      source_security_group_id = module.nlb-elastic[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    # Add more rules as needed
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.volume_size_elastic_2
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

module "ec2-elastic-3" {
  source = "./modules/ec2"

  count = local.create_elastic_ec2 ? 1 : 0

  name                        = local.elastic_3
  instance_type               = local.type_instance_elastic_3
  associate_public_ip_address = false
  key_name                    = local.key_elastic_3
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
      from_port                = 9200
      to_port                  = 9202
      protocol                 = "tcp"
      source_security_group_id = module.nlb-elastic[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    ingress_rule_3 = {
      from_port                = 5601
      to_port                  = 5601
      protocol                 = "tcp"
      source_security_group_id = module.nlb-elastic[0].security_group_id
      type                     = "ingress"
      description              = "http"
    }
    # Add more rules as needed
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.volume_size_elastic_3
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
# ## NLB
module "nlb-elastic" {
  source = "terraform-aws-modules/alb/aws"

  count = local.create_elastic_ec2 ? 1 : 0

  name                       = local.nlb_elastic
  load_balancer_type         = "network"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = local.private_subnets_nlb_elastic
  internal                   = local.internal_nlb_elastic
  enable_deletion_protection = false

  # Security Group
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  security_group_ingress_rules = {
    api_http = {
      from_port   = 9200
      to_port     = 9200
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_http = {
      from_port   = 5601
      to_port     = 5601
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

  listeners = local.listeners_elastic

  target_groups = {
    elastic-target-api = {
      name_prefix = "elk-"
      protocol    = "TCP"
      port        = 9200
      target_type = "instance"
      target_id   = module.ec2-elastic[0].id
    }
    elastic-target-http = {
      name_prefix = "http-"
      protocol    = "TCP"
      port        = 5601
      target_type = "instance"
      target_id   = module.ec2-elastic[0].id
    }
  }

  tags = {
    Environment = local.environment
  }
}
