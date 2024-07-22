resource "aws_s3_bucket" "this" {

  bucket_prefix = var.bucket_name
  force_destroy = true

  tags = merge(
    {
      "Name"     = format("%s-%s", var.bucket_name, var.environment)
      "Platform" = "Storage"
      "Type"     = "S3"
    },
    var.tags,
  )
}

resource "aws_s3_object" "object" {
  for_each = fileset(var.fileset, "**")

  bucket  = aws_s3_bucket.this.id
  key     = each.value
  content = file("${var.fileset_content}${each.value}")
}
