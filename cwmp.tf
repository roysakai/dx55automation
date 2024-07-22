## EC2 tomcat
module "cwmp-tomcat-ipv4" {
  source = "./modules/ec2"

  for_each = toset(local.cwmp_tomcat_ipv4)

  name                        = each.key
  instance_type               = local.cwmp_type_instance_tomcat
  associate_public_ip_address = false
  key_name                    = each.key
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
  user_data_replace_on_change = false

  user_data = templatefile("userdata-cwmp.sh", {
    bucket_name             = aws_s3_bucket.this.bucket
    MESSAGE_BROKER_PASSWORD = local.create_mq ? module.mq[0].secret_string : module.secret-manager[0].secret_string_custom
    MESSAGE_BROKER_USERNAME = local.username_mq
    MESSAGE_BROKER_ADDRESS  = local.create_mq ? module.mq[0].endpoints[0] : module.nlb[0].dns_name
    region_id_cwmp          = local.region_id_cwmp
    cwmp                    = true
    rabbit_instance         = local.create_mq ? false : true
    version_dx              = local.version_dx
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
    # ingress_rule_2 = {
    #   from_port                = 8080
    #   to_port                  = 8080
    #   protocol                 = "tcp"
    #   source_security_group_id = module.cwmp-nlb-ipv4.security_group_id
    #   type                     = "ingress"
    #   description              = "http"
    # }
    # Adicione mais regras conforme necessário
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.cwmp_volume_size_tomcat
      tags = {
        Name = "root-block"
      }
    },
  ]

  additional_policy = true

  policy_additional = [
    {
      name = "policy-tomcat-s3"
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
              "${aws_s3_bucket.this.arn}/*"
            ],
          },
        ],
      })
    }
  ]


  tags = merge(
    {
      Environment = local.environment
    },
    local.tags
  )

  depends_on = [module.rds]

}

module "cwmp-tomcat-ipv6" {
  source = "./modules/ec2"

  for_each = toset(local.cwmp_tomcat_ipv6)

  name                        = each.key
  instance_type               = local.cwmp_type_instance_tomcat_ipv6
  associate_public_ip_address = false
  key_name                    = each.key
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
  user_data_replace_on_change = false

  user_data = templatefile("userdata-cwmp.sh", {
    bucket_name             = aws_s3_bucket.this.bucket
    MESSAGE_BROKER_PASSWORD = local.create_mq ? module.mq[0].secret_string : module.secret-manager[0].secret_string_custom
    MESSAGE_BROKER_USERNAME = local.username_mq
    MESSAGE_BROKER_ADDRESS  = local.create_mq ? module.mq[0].endpoints[0] : module.nlb[0].dns_name
    region_id_cwmp          = local.region_id_cwmp
    cwmp                    = true
    rabbit_instance         = local.create_mq ? false : true
    version_dx              = local.version_dx
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
    # ingress_rule_2 = {
    #   from_port                = 8080
    #   to_port                  = 8080
    #   protocol                 = "tcp"
    #   source_security_group_id = module.cwmp-nlb-ipv6.security_group_id
    #   type                     = "ingress"
    #   description              = "http"
    # }
    # Adicione mais regras conforme necessário
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.cwmp_volume_size_tomcat_ipv6
      tags = {
        Name = "root-block"
      }
    },
  ]

  additional_policy = true
  policy_additional = [
    {
      name = "policy-tomcat-s3"
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
              "${aws_s3_bucket.this.arn}/*"
            ],
          },
        ],
      })
    }
  ]

  tags = merge(
    {
      Environment = local.environment
    },
    local.tags
  )
}

## NLB
module "cwmp-nlb-ipv4" {
  source = "terraform-aws-modules/alb/aws"

  name                       = local.nlb_cwmp4
  load_balancer_type         = "network"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_ids
  enable_deletion_protection = false

  # Security Group
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  security_group_ingress_rules = {
    p_http = {
      from_port   = 7547
      to_port     = 7547
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    p_http_2 = {
      from_port   = 8048
      to_port     = 8048
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 445
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

  listeners = local.listeners_cwmp4

  target_groups = {
    ex-target-http = {
      name_prefix = "pref-"
      protocol    = "TCP"
      port        = 7547
      target_type = "instance"
      target_id   = [for v in module.cwmp-tomcat-ipv4 : v.id][0]

      stickiness = {
        type = "source_ip"
      }
    }
    cwmp4-target-http = {
      name_prefix = "rb2-"
      protocol    = "TCP"
      port        = 8048
      target_type = "instance"
      target_id   = [for v in module.cwmp-tomcat-ipv4 : v.id][1]

      stickiness = {
        type = "source_ip"
      }
    }
  }

  tags = {
    Environment = local.environment
  }
}

module "cwmp-nlb-ipv6" {

  source = "terraform-aws-modules/alb/aws"

  name                       = local.nlb_cwmp6
  load_balancer_type         = "network"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_ids
  enable_deletion_protection = false
  ip_address_type            = "dualstack"

  # Security Group
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  security_group_ingress_rules = {
    p_http = {
      from_port   = 7547
      to_port     = 7547
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    p_http_2 = {
      from_port   = 8048
      to_port     = 8048
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 445
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

  listeners = local.listeners_cwmp6

  target_groups = {
    ex-target-http = {
      name_prefix = "pref-"
      protocol    = "TCP"
      port        = 7547
      target_type = "instance"
      target_id   = [for v in module.cwmp-tomcat-ipv6 : v.id][0]

      stickiness = {
        type = "source_ip"
      }
    }
    cwmp6-target-http = {
      name_prefix = "rb2-"
      protocol    = "TCP"
      port        = 8048
      target_type = "instance"
      target_id   = [for v in module.cwmp-tomcat-ipv6 : v.id][1]

      stickiness = {
        type = "source_ip"
      }
    }
  }

  tags = {
    Environment = local.environment
  }
}
