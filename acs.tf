## EC2
module "acs" {
  source = "./modules/ec2"

  name                        = local.acs
  instance_type               = local.acs_type_instance
  associate_public_ip_address = false
  key_name                    = local.acs_key
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
  user_data_replace_on_change = false

  user_data = templatefile("userdata-acs.sh", {
    bucket_name             = aws_s3_bucket.this.bucket
    host_db                 = module.rds[0].address
    port_db                 = "3306"
    username                = local.username
    acs_name                = local.acs
    acs_name6               = local.acs_tomcat_2
    password                = local.manage_master_user_password ? module.rds[0].secret_string_manager : module.rds[0].secret_string_custom
    database                = local.dbname
    MESSAGE_BROKER_PASSWORD = local.create_mq ? module.mq[0].secret_string : module.secret-manager[0].secret_string_custom
    MESSAGE_BROKER_USERNAME = local.username_mq
    MESSAGE_BROKER_ADDRESS  = local.create_mq ? module.mq[0].endpoints[0] : module.nlb[0].dns_name
    license_key_acs         = local.license_key_acs
    license_key_ums         = local.license_key_ums
    license_key_cwmp        = local.license_key_cwmp
    version_dx              = local.version_dx
    region_id_acs           = local.region_id_acs
    REDIS_CONS              = local.cluster_mode_enabled ? module.elasticache-redis[0].configuration_endpoint_address : module.elasticache-redis[0].instance_endpoint
    REDIS_PASSWORD          = module.elasticache-redis[0].secret_string_custom
    acs                     = true
    rabbit_instance_acs     = local.create_mq ? false : true
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
    #   source_security_group_id = module.acs-nlb-ipv4.security_group_id
    #   type                     = "ingress"
    #   description              = "http"
    # }
    # Add more rules as needed
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.acs_volume_size
      tags = {
        Name = "root-block"
      }
    },
  ]

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

module "acs2" {
  source = "./modules/ec2"

  name                        = local.acs_tomcat_2
  instance_type               = local.acs_type_instance_tomcat_2
  associate_public_ip_address = false
  key_name                    = local.acs_tomcat_2_key
  eip                         = false
  subnet_id                   = element(module.vpc.private_ids, 0)
  ami                         = local.ami
  encrypted                   = false
  user_data_replace_on_change = false

  user_data = templatefile("userdata-acs.sh", {
    bucket_name             = aws_s3_bucket.this.bucket
    host_db                 = module.rds[0].address
    port_db                 = "3306"
    username                = local.username
    acs_name                = local.acs
    acs_name6               = local.acs_tomcat_2
    password                = local.manage_master_user_password ? module.rds[0].secret_string_manager : module.rds[0].secret_string_custom
    MESSAGE_BROKER_PASSWORD = local.create_mq ? module.mq[0].secret_string : module.secret-manager[0].secret_string_custom
    MESSAGE_BROKER_USERNAME = local.username_mq
    MESSAGE_BROKER_ADDRESS  = local.create_mq ? module.mq[0].endpoints[0] : module.nlb[0].dns_name
    license_key_acs         = local.license_key_acs
    license_key_ums         = local.license_key_ums
    license_key_cwmp        = local.license_key_cwmp
    version_dx              = local.version_dx
    region_id_acs           = local.region_id_acs
    REDIS_CONS              = local.cluster_mode_enabled ? module.elasticache-redis[0].configuration_endpoint_address : module.elasticache-redis[0].instance_endpoint
    REDIS_PASSWORD          = module.elasticache-redis[0].secret_string_custom
    acs                     = true
    rabbit_instance_acs     = local.create_mq ? false : true
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
    #   from_port                = 8090
    #   to_port                  = 8090
    #   protocol                 = "tcp"
    #   source_security_group_id = module.acs-nlb-ipv4.security_group_id
    #   type                     = "ingress"
    #   description              = "http"
    # }
    # Add more rules as needed
  }

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = local.acs_volume_size_tomcat_2
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

## NLB
module "acs-nlb-ipv4" {
  source = "terraform-aws-modules/alb/aws"

  name                       = local.nlb_acs4
  load_balancer_type         = "network"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_ids
  enable_deletion_protection = false
  internal                   = local.internal_acs

  # Security Group
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  security_group_ingress_rules = {
    all_http = {
      from_port   = 8080
      to_port     = 8090
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

  listeners = local.listeners_acs4

  target_groups = {
    ex-target-http = {
      name_prefix = "acs-"
      protocol    = "TCP"
      port        = 8080
      target_type = "instance"
      target_id   = module.acs.id

      stickiness = {
        type = "source_ip"
      }
    }
    acs-target-http-2 = {
      name_prefix = "acs2-"
      protocol    = "TCP"
      port        = 8090
      target_type = "instance"
      target_id   = module.acs2.id

      stickiness = {
        type = "source_ip"
      }
    }
  }

  tags = {
    Environment = local.environment
  }
}
