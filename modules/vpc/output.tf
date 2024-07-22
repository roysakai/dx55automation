output "private_ids" {
  description = "Output subnet private"
  value       = aws_subnet.private.*.id
}

output "private_cidrs" {
  description = "Output subnet private"
  value       = aws_subnet.private.*.cidr_block
}

output "public_ids" {
  description = "Output subnet public"
  value       = aws_subnet.public.*.id
}

output "public_cidrs" {
  description = "Output subnet public"
  value       = aws_subnet.public.*.cidr_block
}

output "vpc_id" {
  description = "Output vpc id"
  value       = aws_vpc.this.id
}

output "vpc_name" {
  description = "Output vpc name"
  value       = aws_vpc.this.tags.Name
}

output "vpc_cidr" {
  description = "Output vpc cidr"
  value       = aws_vpc.this.cidr_block
}


output "igw" {
  description = "Output vpc cidr"
  value       = try(aws_internet_gateway.this[0].id, "")
}

output "nat" {
  description = "Output vpc cidr"
  value       = try(aws_nat_gateway.this[0].id, "")
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = try(aws_vpc.this.ipv6_cidr_block, null)
}