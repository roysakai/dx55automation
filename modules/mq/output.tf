output "arn" {
  description = "ARN of the broker."
  value       = aws_mq_broker.this.arn
}

output "id" {
  description = "Unique ID that Amazon MQ generates for the broker."
  value       = aws_mq_broker.this.id
}

output "instances" {
  description = "List of information about allocated brokers (both active & standby)."
  value       = aws_mq_broker.this.instances.0.ip_address
}

output "endpoints" {
  description = "Broker's wire-level protocol endpoints in the following order & format referenceable e.g."
  value       = aws_mq_broker.this.instances.0.endpoints
}

output "secret_string" {
  description = "Secret string custom"
  value       = try(jsondecode(aws_secretsmanager_secret_version.this.secret_string)["password"], "")
  sensitive   = true
}
