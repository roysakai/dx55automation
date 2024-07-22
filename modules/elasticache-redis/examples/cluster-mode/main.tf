# module "elasticache-redis" {
#   source = "../"

#   family     = var.family
#   subnet_ids = ["subnet-xxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx"]

#   redis-name                 = var.redis-name
#   redis-instance-type        = var.redis-instance-type
#   redis-engine-version       = var.redis-engine-version
#   tls                        = var.tls
#   redis-port                 = var.redis-port
#   apply_immediately          = var.apply_immediately
#   security_group_ids         = ["sg-xxxxxxxxxxxxxxx"]
#   environment                = var.environment

#   multi_az_enabled           = true
#   cluster_mode_enabled       = true
#   automatic-failover-enabled = true
#   num_node_groups            = 2
#   replicas_per_node_group    = 1
# }