variable "identifier" {
  description = "Name identifier"
  type        = string
}

variable "dbname" {
  description = "Name database"
  type        = string
}

variable "username" {
  description = "username database"
  type        = string
}

variable "parametergroup" {
  description = "Parameter group database"
  type        = string
  default     = null
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager. Cannot be set if password is provided."
  type        = bool
  default     = true
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = ""
}

variable "ca_cert_identifier" {
  description = "Identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-rsa2048-g1"
}

variable "port_db" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

variable "name_subnet_group" {
  description = "The name of the DB subnet group. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = null
}

variable "password" {
  description = "username database"
  type        = string
  default     = null
}

variable "allow_major_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically "
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ "
  type        = bool
  default     = false
}

variable "rds_subnets" {
  description = "Subnet-groups database"
  type        = list(string)
  default     = []
}

variable "dbengineversion" {
  description = "Version database"
  type        = string
  default     = "8.0.34"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "dbengine" {
  description = "Type engine database"
  type        = string
  default     = "mysql"
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Instance tags to snapshots."
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically "
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. "
  type        = bool
  default     = false
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  type        = bool
  default     = false
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled"
  type        = string
  default     = "03:00-06:00"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_retention_period" {
  description = "Backup retention"
  type        = number
  default     = 7
}

variable "performance_insights_enabled" {
  description = "specifies whether Performance Insights are enabled."
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "storage encrypted engine database"
  type        = bool
  default     = "false"
}

variable "storage_type" {
  description = "Type storage database"
  type        = string
  default     = "gp3"
}

variable "size" {
  description = "Size storage database"
  type        = number
  default     = 20
}

variable "dbinstanceclass" {
  description = "Type instance database"
  type        = string
  default     = "db.t3.micro"
}

variable "skip_final_snapshot" {
  description = "Final snapshot database"
  type        = bool
  default     = false
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier"
  type        = string
  default     = null
}

variable "replica_mode" {
  description = "Specifies whether the replica is in either mounted or open-read-only mode"
  type        = string
  default     = null
}

variable "iops" {
  description = "Provisioned IOPS (I/O operations per second) value."
  type        = number
  default     = null
}

variable "proxy_create" {
  description = "Create proxy"
  type        = bool
  default     = false
}

variable "engine_family" {
  description = " The kinds of databases that the proxy can connect to. This value determines which database network protocol the proxy recognizes when it interprets network traffic to and from the database. The engine family applies to MySQL and PostgreSQL for both RDS and Aurora. Valid values are MYSQL and POSTGRESQL."
  type        = string
  default     = "POSTGRESQL"
}

variable "create_parameter_group" {
  description = "create parameter group"
  type        = bool
  default     = false
}

variable "family" {
  description = "The family of the ElastiCache parameter group"
  type        = string
  default     = "mysql8.0"
}

variable "parameter" {
  description = "additional parameters modifyed in parameter group"
  type        = list(map(any))
  default     = []
}

variable "connection_pool_config" {
  description = "The settings that determine the size and behavior of the connection pool for the target group"
  type        = list(map(any))
  default     = []
}

variable "additional_rules_security_group" {
  description = "Rules security group"
  type        = any
  default     = {}
}

variable "create_replica" {
  description = "Create replica"
  type        = bool
  default     = false
}