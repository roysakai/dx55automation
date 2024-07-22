##variables security-group
variable "redis-name" {
  description = "Name to be used the resources as identifier"
  type        = string
}

variable "create_parameter_group" {
  type    = bool
  default = false
}

variable "family" {
  description = "The family of the ElastiCache parameter group"
  type        = string
  default     = "redis6.x"
}

variable "description" {
  description = "Description instance"
  type        = string
  default     = "Redis manager terraform"
}

variable "subnet_ids" {
  description = "Subnet id"
  type        = list(any)
  default     = []
}

variable "apply_immediately" {
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Env tags"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "redis-instance-type" {
  description = "Instance class to be used"
  type        = string
  default     = ""
}

variable "redis-instance-number" {
  description = "Number of cache clusters (primary and replicas) this replication,  If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. Conflicts with num_node_groups"
  type        = number
  default     = null
}

variable "redis-password" {
  description = "Password used to access a password protected server. Can be specified only if transit_encryption_enabled = true"
  type        = string
  default     = ""
}

variable "num_node_groups" {
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger a resizing operation before other settings modifications. Conflicts with redis-instance-number"
  type        = number
  default     = null
}

variable "replicas_per_node_group" {
  description = "Number of replica nodes in each node group. Changing this number will trigger a resizing operation before other settings modifications. Valid values are 0 to 5."
  type        = number
  default     = null
}

variable "redis-engine-version" {
  description = "Version number of the cache engine to be used for the cache clusters in this replication group"
  type        = string
  default     = "6.0"
}

variable "redis-port" {
  description = "Port used redis"
  type        = string
  default     = "6379"
}

variable "at_rest_encryption_enabled" {
  description = "Whether to enable encryption at rest."
  type        = bool
  default     = false
}

variable "tls" {
  description = "Whether to enable encryption in transit."
  type        = bool
  default     = false
}

variable "automatic-failover-enabled" {
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, num_cache_clusters must be greater than 1. Must be enabled for Redis (cluster mode enabled) replication groups."
  type        = bool
  default     = false
}

variable "parameter" {
  description = "additional parameters modifyed in parameter group"
  type        = list(map(any))
  default     = []
}

variable "multi_az_enabled" {
  description = "Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic_failover_enabled must also be enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "cluster_mode_enabled" {
  description = "Enable cluster mode default is 'false' used in conjunction with 'multi_az_enabled' and automatic-failover-enabled"
  type        = bool
  default     = false
}

variable "snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster"
  type        = string
  default     = "02:00-03:00"
}

variable "snapshot_retention_limit" {
  description = "Number of days for which ElastiCache will retain automatic cache cluster"
  type        = number
  default     = 1
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00"
  type        = string
  default     = "sun:05:00-sun:09:00"
}

variable "auto_minor_version_upgrade" {
  description = "Automatically schedule cluster upgrade to the latest minor version, once it becomes available. Cluster upgrade will only be scheduled during the maintenance window."
  type        = bool
  default     = false
}

variable "additional_rules_security_group" {
  description = "Rules security group"
  type        = any
  default     = {}
}

variable "username" {
  description = "username database"
  type        = string
  default     = "admin"
}
