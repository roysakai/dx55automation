locals {
  environment = "staging"
  tags = {
    Environment = "staging"
  }
  bucket_name         = "ansible-tomcat-"
  bucket_name_rabbit  = "ansible-rabbit-"
  bucket_name_elastic = "ansible-elastic-"

  #ami                = "ami-011ef2017d41cb239" region us-east-1
  #ami = "ami-02391db2758465a87" # por account e region us-east-2
  ami = "ami-039dafac71304f23a" # region Calgary
  ## SSL
  #certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"

  ## VPC

  name                             = "my-vpc-${local.environment}"
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  private_subnets                  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets                   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  map_public_ip_on_launch          = true
  igwname                          = "my-igw"
  natname                          = "my-nat"
  rtname                           = "my-rt"
  enable_ipv6                      = true
  assign_generated_ipv6_cidr_block = true
  public_subnet_ipv6_prefix        = [0, 1, 2]
  private_subnet_ipv6_prefix       = [3, 4, 5]

  ## TOMCAT cwmp
  
  ## VARIABLES ANSIBLE
  region_id_cwmp = "104" # 1-254

  cwmp_tomcat_ipv4 = [
    "app-cwmp-1",
    "app-cwmp-2"
  ]
  cwmp_type_instance_tomcat = "t3a.medium"
  cwmp_volume_size_tomcat   = 10

  cwmp_tomcat_ipv6 = [
    "app-cwmp6-1",
    "app-cwmp6-2"
  ]
  cwmp_type_instance_tomcat_ipv6 = "t3a.medium"
  cwmp_volume_size_tomcat_ipv6   = 10

  ## ALB
  nlb_cwmp4 = "cwmp-nlb"
  listeners_cwmp4 = {
    ex-tcp-http = {
      port     = 7547
      protocol = "TCP"
      forward = {
        target_group_key = "ex-target-http"
      }
    }
    ex-tcp-http-2 = {
      port     = 8048
      protocol = "TCP"
      forward = {
        target_group_key = "cwmp4-target-http"
      }
    }

    ## SSL
    # ex-tls = {
    #   port            = 443
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "ex-target-http"
    #   }
    # }
    # ex-tls-2 = {
    #   port            = 444
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "cwmp4-target-http"
    #   }
    # }
  }
  nlb_cwmp6 = "cwmp-alb6"
  listeners_cwmp6 = {
    ex-tcp-http = {
      port     = 7547
      protocol = "TCP"
      forward = {
        target_group_key = "ex-target-http"
      }
    }
    ex-tcp-http-2 = {
      port     = 8048
      protocol = "TCP"
      forward = {
        target_group_key = "cwmp6-target-http"
      }
    }

    ## SSL
    # ex-tls = {
    #   port            = 443
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "ex-target-http"
    #   }
    # }
    # ex-tls-2 = {
    #   port            = 444
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "cwmp6-target-http"
    #   }
    # }
  }

  ## TOMCAT xmpp

  xmpp_tomcat_ipv4          = "app-xmpp"
  xmpp_type_instance_tomcat = "t3a.medium"
  xmpp_volume_size_tomcat   = 10
  xmpp_tomcat_ipv4_key      = "tomcat-xmpp-key4"

  xmpp_tomcat_ipv6               = "app-xmpp6"
  xmpp_type_instance_tomcat_ipv6 = "t3a.medium"
  xmpp_volume_size_tomcat_ipv6   = 10
  xmpp_tomcat_ipv6_key           = "tomcat-xmpp-key6"

  nlb_xmpp4 = "xmpp-nlb"
  listeners_xmpp4 = {
    ex-tcp-http = {
      port     = 5222
      protocol = "TCP"
      forward = {
        target_group_key = "ex-target-http"
      }
    }

    ## SSL
    # ex-tls = {
    #   port            = 443
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "ex-target-http"
    #   }
    # }
  }

  nlb_xmpp6 = "xmpp-nlb6"
  listeners_xmpp6 = {
    ex-tcp-http = {
      port     = 5223
      protocol = "TCP"
      forward = {
        target_group_key = "xmpp6-target-http"
      }
    }

    ## SSL
    # ex-tls = {
    #   port            = 5223
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "xmpp6-target-http"
    #   }
    # }
  }

  ## ACS

  acs               = "acs"
  acs_type_instance = "t3a.medium"
  acs_volume_size   = 10
  acs_key           = "acs4-key"

  acs_tomcat_2               = "acs6"
  acs_type_instance_tomcat_2 = "t3a.medium"
  acs_volume_size_tomcat_2   = 10
  acs_tomcat_2_key           = "acs6-key"

  ## VARIABLES ANSIBLE 

  license_key_acs  = "05X-ACS001-34EB-3D92-1601-423B"
  license_key_ums  = "06X-RCM100-0B9C-8E3D-BA7F-6C42"
  license_key_cwmp = "05X-CWM001-FD9D-D507-DE65-9B95"
  version_dx       = "5.5"
  region_id_acs    = "104"

  nlb_acs4     = "acs-nlb"
  internal_acs = false

  listeners_acs4 = {
    ex-tcp-http = {
      port     = 8080
      protocol = "TCP"
      forward = {
        target_group_key = "ex-target-http"
      }
    }

    acs-target-http-2 = {
      port     = 8090
      protocol = "TCP"
      forward = {
        target_group_key = "acs-target-http-2"
      }
    }

    ## SSL
    # ex-tls = {
    #   port            = 443
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "ex-target-http"
    #   }
    # }
    # ex-tls-2 = {
    #   port            = 444
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "acs-target-http-2"
    #   }
    # }
  }

  ## MSK
  create_msk = false

  msk_name                  = "kafka"
  broker_node_instance_type = "kafka.t3.small"
  kafka_version             = "3.5.1"


  ## Rabbit

  create_mq = true

  broker_name          = "mq-test"
  engine_type          = "RabbitMQ"
  engine_version       = "3.12.13"
  host_instance_type   = "mq.t3.micro"     ## "mq.m5.large" ## 2VCPU 8GB
  deployment_mode      = "SINGLE_INSTANCE" ## "CLUSTER_MULTI_AZ"
  username_mq          = "admin"
  apply_immediately_mq = false
  subnet_ids_mq        = [module.vpc.private_ids[0]]

  ## EC2 rabbit

  create_rabbit_ec2 = false

  rabbit_1             = "rabbitmq-1"
  key_rabbit_1         = "rabbit-key"
  type_instance_rabbit = "t3a.medium"
  volume_size_rabbit   = 10
  user_ec2_rabbit      = "rocky"

  rabbit_2               = "rabbitmq-2"
  key_rabbit_2           = "rabbit-key_2"
  type_instance_rabbit_2 = "t3a.medium"
  volume_size_rabbit_2   = 10

  rabbit_3               = "rabbitmq-3"
  key_rabbit_3           = "rabbit-key_3"
  type_instance_rabbit_3 = "t3a.medium"
  volume_size_rabbit_3   = 10


  nlb_rabbit          = "rabbit-nlb"
  internal            = false
  private_subnets_nlb = module.vpc.public_ids

  listeners_rabbit = {
    ex-tcp-http = {
      port     = 15672
      protocol = "TCP"
      forward = {
        target_group_key = "rabbit-target-http"
      }
    }
    ex-tcp-api = {
      port     = 5672
      protocol = "TCP"
      forward = {
        target_group_key = "rabbit-target-api"
      }
    } 

    ## SSL
    # ex-tls = {
    #   port            = 443
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "rabbit-target-http"
    #   }
    # }
    # ex-tls-2 = {
    #   port            = 444
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "rabbit-target-api"
    #   }
    # }
  }

  ## Opensearch
  create_opensearch = false

  domain                   = "os-staging"
  cluster_version          = "2.11"
  size                     = 60
  instance_type            = "t3.small.search"
  zone_awareness_enabled   = false
  availability_zone_count  = 2
  instance_count           = 3
  dedicated_master_enabled = true
  dedicated_master_count   = 3
  dedicated_master_type    = "t3.small.search"

  ## EC2 elastic

  create_elastic_ec2 = false

  elastic_1             = "elastic-1"
  key_elastic_1         = "elastic-key"
  type_instance_elastic = "t3a.medium"
  volume_size_elastic   = 10
  user_ec2_elastic      = "rocky"
  version_elastic       = "8.14.0"

  elastic_2               = "elastic-2"
  key_elastic_2           = "elastic-key_2"
  type_instance_elastic_2 = "t3a.medium"
  volume_size_elastic_2   = 10

  elastic_3               = "elastic-3"
  key_elastic_3           = "elastic-key_3"
  type_instance_elastic_3 = "t3a.medium"
  volume_size_elastic_3   = 10


  nlb_elastic                 = "elastic-nlb"
  internal_nlb_elastic        = false
  private_subnets_nlb_elastic = module.vpc.public_ids

  listeners_elastic = {
    elastic-tcp-api = {
      port     = 9200
      protocol = "TCP"
      forward = {
        target_group_key = "elastic-target-api"
      }
    }
    ex-tcp-http = {
      port     = 5601
      protocol = "TCP"
      forward = {
        target_group_key = "elastic-target-http"
      }
    }

    ## SSL
    # ex-tls = {
    #   port            = 443
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "elastic-target-api"
    #   }
    # }
    # ex-tls-2 = {
    #   port            = 444
    #   protocol        = "TLS"
    #   certificate_arn = local.certificate_arn
    #   forward = {
    #     target_group_key = "elastic-target-http"
    #   }
    # }
  }

  ## RDS
  create_rds = true

  identifier                          = "mysql-test"
  size_db                             = 20
  storage_encrypted                   = false
  storage_type                        = "gp3"
  dbname                              = "mysqltest"
  dbengine                            = "mysql"
  dbengineversion                     = "8.0.36"
  dbinstanceclass                     = "db.t3.micro"
  username                            = "admin"
  skip_final_snapshot                 = true
  publicly_accessible                 = false
  apply_immediately                   = false
  maintenance_window                  = "Mon:00:00-Mon:03:00"
  backup_retention_period             = 7
  backup_window                       = "03:00-06:00"
  copy_tags_to_snapshot               = false
  auto_minor_version_upgrade          = false
  allow_major_version_upgrade         = false
  iam_database_authentication_enabled = false
  deletion_protection                 = false
  multi_az                            = false
  performance_insights_enabled        = false
  port_db                             = 3306
  family                              = "mysql8.0"

  create_replica              = false

  ## Não deve ser usado com read-replicas
  manage_master_user_password = false

  create_parameter_group = false

  # parameter = [
  #   {
  #     name  = "character_set_server"
  #     value = "utf8"
  #   },
  #   {
  #     name  = "character_set_client"
  #     value = "utf8"
  #   }
  # ]

  # additional_rules_security_group = {

  #   ingress_rule_1 = {
  #     from_port   = 3306
  #     to_port     = 3306
  #     protocol    = "tcp"
  #     cidr_blocks = ["172.16.3.10/32"]
  #     description = "DB1"
  #     type        = "ingress"
  #   },
  #   ingress_rule_2 = {
  #     from_port   = 3306
  #     to_port     = 3306
  #     protocol    = "tcp"
  #     cidr_blocks = ["172.16.3.11/32"]
  #     description = "DB2"
  #     type        = "ingress"
  #   }
  #   # Adicione mais regras conforme necessário
  # }

  ## REDIS
  create_redis = true

  redis_name                 = "my-redis"
  redis_instance_type        = "cache.t3.micro"
  redis_engine_version       = "6.2"
  tls                        = true
  redis_port                 = 6379
  apply_immediately_redis    = false
  at_rest_encryption_enabled = true
  ## Se multi cluster essa variavel é = 0
  redis-instance-number = 1

  ## Se Multi cluster utilize abaixo
  automatic_failover_enabled   = false
  num_node_groups              = 0
  replicas_per_node_group      = 0
  create_parameter_group_redis = false
  multi_az_enabled             = false
  cluster_mode_enabled         = false
  #   parameter = [
  #     {
  #       name  = "repl-backlog-size"
  #       value = "16384"
  #     }
  #   ]


}
