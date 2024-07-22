## MSK
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  count = local.create_msk ? 1 : 0

  name        = "${local.msk_name}-security-group"
  description = "Security group for ${local.msk_name}"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.private_cidrs
  ingress_rules = [
    "kafka-broker-tcp",
    "kafka-broker-tls-tcp"
  ]

  tags = local.tags
}


module "msk_kafka_cluster" {
  source = "terraform-aws-modules/msk-kafka-cluster/aws"

  count = local.create_msk ? 1 : 0

  name                   = local.msk_name
  kafka_version          = local.kafka_version
  number_of_broker_nodes = 3

  broker_node_client_subnets  = module.vpc.private_ids
  broker_node_instance_type   = local.broker_node_instance_type
  broker_node_security_groups = module.security_group[0].security_group_id

  tags = local.tags
}
