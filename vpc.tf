## VPC
module "vpc" {
  source = "./modules/vpc"

  name                 = local.name
  cidr_block           = local.cidr_block
  instance_tenancy     = local.instance_tenancy
  enable_dns_support   = local.enable_dns_support
  enable_dns_hostnames = local.enable_dns_hostnames

  tags        = local.tags
  environment = local.environment

  private_subnets         = local.private_subnets
  public_subnets          = local.public_subnets
  map_public_ip_on_launch = local.map_public_ip_on_launch

  enable_ipv6                      = local.enable_ipv6
  assign_generated_ipv6_cidr_block = local.assign_generated_ipv6_cidr_block
  public_subnet_ipv6_prefix        = local.public_subnet_ipv6_prefix
  private_subnet_ipv6_prefix       = local.private_subnet_ipv6_prefix

  igwname = local.igwname
  natname = local.natname
  rtname  = local.rtname
}
