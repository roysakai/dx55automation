## Variables elasticache

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    Environment = "hml"
  }
}

variable "redis-name" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = "tf-redis-cluster"
}

variable "family" {
  description = "The family of the ElastiCache parameter group"
  type        = string
  default     = "redis6.x"
}

variable "redis-instance-type" {
  description = "Instance class to be used"
  type        = string
  default     = "cache.t3.micro"
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

variable "tls" {
  description = "Whether to enable encryption in transit."
  type        = bool
  default     = false
}
