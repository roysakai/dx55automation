variable "name" {
  description = "Name identifier"
  type        = string
}

variable "username" {
  description = "username account"
  type        = string
  default     = ""
}

variable "secret_string" {
  description = "secret used"
  type        = string
  default     = null
}
