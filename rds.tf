## RDS
module "rds" {
  source = "./modules/rds"

  count = local.create_rds ? 1 : 0

  identifier                          = local.identifier
  size                                = local.size_db
  storage_encrypted                   = local.storage_encrypted
  storage_type                        = local.storage_type
  dbname                              = local.dbname
  dbengine                            = local.dbengine
  dbengineversion                     = local.dbengineversion
  dbinstanceclass                     = local.dbinstanceclass
  username                            = local.username
  skip_final_snapshot                 = local.skip_final_snapshot
  publicly_accessible                 = local.publicly_accessible
  apply_immediately                   = local.apply_immediately
  maintenance_window                  = local.maintenance_window
  backup_retention_period             = local.backup_retention_period
  backup_window                       = local.backup_window
  copy_tags_to_snapshot               = local.copy_tags_to_snapshot
  auto_minor_version_upgrade          = local.auto_minor_version_upgrade
  allow_major_version_upgrade         = local.allow_major_version_upgrade
  iam_database_authentication_enabled = local.iam_database_authentication_enabled
  deletion_protection                 = local.deletion_protection
  multi_az                            = local.multi_az
  performance_insights_enabled        = local.performance_insights_enabled
  port_db                             = local.port_db
  family                              = local.family

  create_replica              = local.create_replica
  manage_master_user_password = local.manage_master_user_password
  
  tags = local.tags

  environment       = local.environment
  name_subnet_group = "subnet-group-rds"
  rds_subnets       = module.vpc.private_ids

  create_parameter_group = local.create_parameter_group

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
}
