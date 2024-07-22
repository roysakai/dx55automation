output "arn" {
  value = aws_opensearch_domain.this.arn
}

output "domain_id" {
  value = aws_opensearch_domain.this.domain_id
}

output "domain_name" {
  value = aws_opensearch_domain.this.domain_name
}

output "endpoint" {
  value = aws_opensearch_domain.this.endpoint
}

output "kibana_endpoint" {
  value = aws_opensearch_domain.this.dashboard_endpoint
}

output "region" {
  value = data.aws_region.current.name
}

output "account" {
  value = data.aws_caller_identity.current.account_id
}

output "secret_string" {
  description = "Secret string custom"
  value       = try(jsondecode(aws_secretsmanager_secret_version.this.secret_string)["password"], "")
  sensitive   = true
}
