output "arn" {
  description = "Result password"
  value       = aws_secretsmanager_secret_version.this.arn
}

output "secret_string_custom" {
  description = "Secret string custom"
  value       = try(jsondecode(aws_secretsmanager_secret_version.this.secret_string)["password"], "")
  sensitive   = true
}
