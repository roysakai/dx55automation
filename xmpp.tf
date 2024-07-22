## EC2 tomcat
module "xmpp-tomcat-ipv4" {
  source = "./modules/ec2"

  name                        = local.xmpp_tomcat_ipv4
  instance_type               = local.xmpp_type_instance_tomcat
  associate_public_ip_address = false
  key_name                    = local.xmpp_tomcat_ipv4_key
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
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
    # ingress_rule_2 = {
    #   from_port                = 8080
    #   to_port                  = 8080
    #   protocol                 = "tcp"
    #   source_security_group_id = module.xmpp-nlb-ipv4.security_group_id
    #   type                     = "ingress"
    #   description              = "http"
    # }
    # Adicione mais regras conforme necessário
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.xmpp_volume_size_tomcat
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

module "xmpp-tomcat-ipv6" {
  source = "./modules/ec2"

  name                        = local.xmpp_tomcat_ipv6
  instance_type               = local.xmpp_type_instance_tomcat_ipv6
  associate_public_ip_address = false
  key_name                    = local.xmpp_tomcat_ipv6_key
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
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
    # ingress_rule_2 = {
    #   from_port                = 8080
    #   to_port                  = 8080
    #   protocol                 = "tcp"
    #   source_security_group_id = module.xmpp-nlb-ipv6.security_group_id
    #   type                     = "ingress"
    #   description              = "http"
    # }
    # Adicione mais regras conforme necessário
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.xmpp_volume_size_tomcat_ipv6
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
module "xmpp-nlb-ipv4" {
  source = "terraform-aws-modules/alb/aws"

  name                       = local.nlb_xmpp4
  load_balancer_type         = "network"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_ids
  enable_deletion_protection = false

  # Security Group
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  security_group_ingress_rules = {
    all_http = {
      from_port   = 5222
      to_port     = 5223
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

  listeners = local.listeners_xmpp4

  target_groups = {
    ex-target-http = {
      name_prefix = "pref-"
      protocol    = "TCP"
      port        = 5222
      target_type = "instance"
      target_id   = module.xmpp-tomcat-ipv4.id

      stickiness = {
        type = "source_ip"
      }
    }
  }

  tags = {
    Environment = local.environment
  }
}

module "xmpp-nlb-ipv6" {

  source = "terraform-aws-modules/alb/aws"

  name                       = local.nlb_xmpp6
  load_balancer_type         = "network"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_ids
  enable_deletion_protection = false
  ip_address_type            = "dualstack"

  # Security Group
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  security_group_ingress_rules = {
    all_http = {
      from_port   = 5222
      to_port     = 5223
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

  listeners = local.listeners_xmpp6

  target_groups = {
    xmpp6-target-http = {
      name_prefix = "pref-"
      protocol    = "TCP"
      port        = 5223
      target_type = "instance"
      target_id   = module.xmpp-tomcat-ipv6.id

      stickiness = {
        type = "source_ip"
      }
    }
  }

  tags = {
    Environment = local.environment
  }
}

