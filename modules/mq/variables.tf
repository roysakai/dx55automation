variable "additional_rules_security_group" {
  description = "Rules security group"
  type        = any
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "port_db" {
  description = "port sg"
  type        = number
  default     = "5671"
}

variable "broker_name" {
  description = "Name of the broker."
  type        = string
  default     = ""
}

variable "engine_type" {
  description = "Type of broker engine. Valid values are ActiveMQ and RabbitMQ."
  type        = string
  default     = "RabbitMQ"
}

variable "engine_version" {
  description = "Version of the broker engine"
  type        = string
  default     = ""
}

variable "configuration" {
  description = "Configuration block for broker configuration. Applies to engine_type of ActiveMQ only."
  type        = any
  default     = []
}

variable "host_instance_type" {
  description = "Broker's instance type. For example, mq.t3.micro, mq.m5.large."
  type        = string
  default     = ""
}

variable "username" {
  description = "Username access UI"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnet-groups database"
  type        = list(string)
  default     = []
}

variable "storage_type" {
  description = "Storage type of the broker. For engine_type ActiveMQ, the valid values are efs and ebs, and the AWS-default is efs. For engine_type RabbitMQ, only ebs is supported. When using ebs, only the mq.m5 broker instance type family is supported."
  type        = string
  default     = "ebs"
}

variable "deployment_mode" {
  description = "Deployment mode of the broker. Valid values are SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ. Default is SINGLE_INSTANCE"
  type        = string
  default     = "SINGLE_INSTANCE"
}

variable "publicly_accessible" {
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets."
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any broker modifications are applied immediately, or during the next maintenance window. Default is false."
  type        = bool
  default     = false

}

variable "auto_minor_version_upgrade" {
  description = " Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available."
  type        = bool
  default     = false
}

variable "logs" {
  description = "Configuration block for broker configuration. Applies to engine_type of ActiveMQ only."
  type        = any
  default     = []
}

variable "maintenance_window_start_time" {
  description = "Configuration block for the maintenance window start time. Detailed below"
  type        = any
  default     = []
}
