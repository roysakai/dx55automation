## Opensearch
module "opensearch" {
  source = "./modules/opensearch"

  count = local.create_opensearch ? 1 : 0

  domain              = local.domain
  cluster_version     = local.cluster_version
  ebs                 = true
  type                = "gp3"
  size                = local.size
  security_advanced   = true
  anonymous_auth      = false
  internal_user       = true
  user                = "admin"
  endpoint            = false
  enforce_https       = true
  node_encryption     = true
  encrypt_at          = true
  tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  cluster_config = {
    instance_type            = local.instance_type
    zone_awareness_enabled   = local.zone_awareness_enabled
    availability_zone_count  = local.availability_zone_count
    instance_count           = local.instance_count
    dedicated_master_enabled = local.dedicated_master_enabled
    dedicated_master_type    = local.dedicated_master_type
    dedicated_master_count   = local.dedicated_master_count

  }

  vpc_cidr = module.vpc.vpc_cidr
  vpc_id   = module.vpc.vpc_id

  vpc_enabled = true
  vpc_options = {
    subnet_ids = [module.vpc.private_ids[0]]
  }
  public_enabled = false
  #cidrs          = ["18.xxx.xx.xxx/32","19.xxx.xx.xxx/32"]

  tags = local.tags
}
