output "bucket-name" {
  description = "The name bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket-id" {
  description = "The id bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket-arn" {
  description = "The arn bucket"
  value       = aws_s3_bucket.this.arn
}