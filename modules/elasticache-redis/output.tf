output "engine" {
  description = "The engine used"
  value       = aws_elasticache_replication_group.redis_replication.engine
}

output "instance_arn" {
  description = "The ARN of the instance"
  value       = aws_elasticache_replication_group.redis_replication.arn
}

output "instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_elasticache_replication_group.redis_replication.primary_endpoint_address
}

output "instance_id" {
  description = "The instance ID"
  value       = aws_elasticache_replication_group.redis_replication.id
}

output "secret_string_custom" {
  description = "Secret string custom"
  value       = try(jsondecode(aws_secretsmanager_secret_version.this.secret_string)["password"], "")
  sensitive   = true
}

output "configuration_endpoint_address" {
  description = "Address of the replication group configuration endpoint when cluster mode is enabled."
  value       = try(aws_elasticache_replication_group.redis_replication.configuration_endpoint_address, "")
}
