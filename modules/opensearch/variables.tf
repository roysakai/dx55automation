variable "domain" {
  description = "Name of the domain."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Env ambient"
  type        = string
  default     = ""

}

variable "cluster_config" {
  description = "Configuration block for the cluster of the domain"
  type        = any
  default = {}
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "zone_awareness_enabled" {
  description = "Whether zone awareness is enabled, set to true for multi-az deploymen"
  type        = bool
  default     = false
}

variable "availability_zone_count" {
  description = "Number of Availability Zones for the domain to use with zone_awareness_enable"
  type        = number
  default     = 2
}

variable "vpc_enabled" {
  description = "Enabled type vpc"
  type        = bool
  default     = false
}

variable "vpc_options" {
  description = "Configuration block for VPC related options. Adding or removing this configuration forces a new resource ([documentation](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-vpc.html#es-vpc-limitations))"
  type        = any
  default     = {}
}

variable "public_enabled" {
  description = "Enabled type public"
  type        = bool
  default     = true

}

variable "cidrs" {
  description = "Subnet ID"
  type        = list(string)
  default     = []
}

variable "cluster_version" {
  description = "Specify the engine version for the Amazon OpenSearch Service domain. For example, OpenSearch_1.0 or Elasticsearch_7.9."
  type        = string
  default     = "2.3"
}

variable "instance_type" {
  description = "Instance type of data nodes in the cluster."
  type        = string
  default     = "t3.small.search"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 1
}

variable "dedicated_master" {
  description = "Whether dedicated main nodes are enabled for the cluster."
  type        = bool
  default     = false
}

variable "security_advanced" {
  description = "Whether advanced security is enabled"
  type        = bool
  default     = true
}

variable "anonymous_auth" {
  description = "Whether Anonymous auth is enabled. Enables fine-grained access control on an existing domain. Ignored unless"
  type        = bool
  default     = false
}

variable "internal_user" {
  description = "Whether the internal user database is enabled"
  type        = bool
  default     = true
}

variable "user" {
  description = "Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if internal_user_database_enabled is set to true"
  type        = string
  default     = "root"
}

variable "password" {
  description = "Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if internal_user_database_enabled is set to true"
  type        = string
  default     = ""
}

variable "endpoint" {
  description = "Whether to enable custom endpoint for the OpenSearch domain"
  type        = bool
  default     = false
}

variable "custom_endpoint" {
  description = "Fully qualified domain for your custom endpoint"
  type        = string
  default     = "es.example.io"
}

variable "enforce_https" {
  description = "Whether or not to require HTTPS"
  type        = bool
  default     = true
}

variable "node_encryption" {
  description = "Configuration block for node-to-node encryption options."
  type        = bool
  default     = true
}

variable "encrypt_at" {
  description = "Configuration block for encrypt at rest options"
  type        = bool
  default     = true
}

variable "tls_security_policy" {
  description = "Name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: Policy-Min-TLS-1-0-2019-07 and Policy-Min-TLS-1-2-2019-07"
  type        = string
  default     = "Policy-Min-TLS-1-2-2019-07"
}

variable "ebs" {
  description = "Whether EBS volumes are attached to data nodes in the domain"
  type        = bool
  default     = true
}

variable "type" {
  description = "Type of EBS volumes attached to data nodes"
  type        = string
  default     = "gp3"
}

variable "size" {
  description = "(Required if ebs_enabled is set to true.) Size of EBS volumes attached to data nodes (in GiB)"
  type        = number
  default     = 60
}
