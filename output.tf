output "mq" {
  value = try(module.mq[0].endpoints[0], "")
}

output "address" {
  value = try(module.rds[0].address, "")
}  

output "redis" {
  value = try(module.elasticache-redis[0].instance_endpoint, "")
}  