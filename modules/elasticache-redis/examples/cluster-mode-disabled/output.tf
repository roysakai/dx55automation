output "cache_instance_arn" {
  description = "The database arn"
  value       = module.elasticache-redis.*.instance_endpoint
}
