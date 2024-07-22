variable "route_table_routes_private" {
  type    = map(any)
  default = {}

}

variable "route_table_routes_public" {
  type    = map(any)
  default = {}
}

variable "create_aws_flow_log" {
  description = "Create vpc flow log"
  type        = bool
  default     = false
}

variable "public_subnets_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "private_subnets_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "iam_role_arn" {
  description = "IAM role flow logs"
  type        = string
  default     = null
}

variable "log_destination_arn" {
  description = "ARN log_destination_arn"
  type        = string
  default     = null
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is default"
  type        = string
  default     = "default"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "cidr_block" {
  description = " The IPv4 CIDR block for the VPC."
  type        = string
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = null
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable dns hostnames"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable dns support"
  type        = bool
  default     = true
}

#variables igw

variable "igwname" {
  description = "Name to be used the resources as identifier"
  type        = string
}

#variables nat
variable "natname" {
  description = "Name to be used the resources as identifier"
  type        = string

}

## routes
variable "rtname" {
  description = "Name to be used the resources as identifier"
  type        = string

}

variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
  type        = bool
  default     = false
}

variable "public_subnet_ipv6_prefix" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "private_subnet_ipv6_prefix" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "assign_generated_ipv6_cidr_block" {
  description = " Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false"
  type        = bool
  default     = false
}

variable "create_nat" {
  description = "Create nat-gateway"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "Create igw-gateway"
  type        = bool
  default     = true
}