locals {
  environment = "staging"
  tags = {
    Environment = "staging"
  }
}
  
module "opensearch" {
  source = "../.."

  domain              = "os-development"
  cluster_version     = "2.11"
  ebs                 = true
  type                = "gp3"
  size                = 60
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
    instance_type           = "t3.small.search"
    zone_awareness_enabled  = false
    availability_zone_count = 2
    instance_count          = 1

  }

  vpc_enabled    = false
  public_enabled = true
  cidrs          = ["18.xxx.xx.xxx/32","19.xxx.xx.xxx/32"]

  tags = local.tags
}
