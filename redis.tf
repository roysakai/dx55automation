module "elasticache-redis" {
  source = "./modules/elasticache-redis"

  count = local.create_redis ? 1 : 0

  family     = "redis6.x"
  subnet_ids = module.vpc.private_ids

  redis-name                 = local.redis_name
  redis-instance-type        = local.redis_instance_type
  redis-engine-version       = local.redis_engine_version
  tls                        = local.tls
  redis-port                 = local.redis_port
  apply_immediately          = local.apply_immediately_redis
  at_rest_encryption_enabled = local.at_rest_encryption_enabled
  redis-instance-number      = local.redis-instance-number
  environment                = local.environment

  ## Cluster Mode
  create_parameter_group = local.create_parameter_group_redis
  #   parameter = [
  #     {
  #       name  = "repl-backlog-size"
  #       value = "16384"
  #     }
  #   ]
  multi_az_enabled           = local.multi_az_enabled
  cluster_mode_enabled       = local.cluster_mode_enabled
  automatic-failover-enabled = local.automatic_failover_enabled
  num_node_groups            = local.num_node_groups
  replicas_per_node_group    = local.replicas_per_node_group
}
