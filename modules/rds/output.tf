output "identifier" {
  description = "The database name"
  value       = aws_db_instance.this.identifier
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_kms_key_id" {
  description = "The ARN for the KMS encryption key."
  value       = aws_db_instance.this.kms_key_id
}

output "secret_string_custom" {
  description = "Secret string custom"
  value       = try(jsondecode(aws_secretsmanager_secret_version.this[0].secret_string)["password"], "")
  sensitive   = true
}

output "secret_string_manager" {
  description = "Secret string manager"
  value       = try(jsondecode(data.aws_secretsmanager_secret_version.manager[0].secret_string)["password"], "")
  sensitive   = true
}

output "address" {
  description = "The database address"
  value       = aws_db_instance.this.address
}