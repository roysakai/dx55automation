## S3
resource "aws_s3_bucket" "this" {
  bucket_prefix = local.bucket_name
  force_destroy = true

  tags = merge(
    {
      "Name"     = format("%s-%s", local.bucket_name, local.environment)
      "Platform" = "Storage"
      "Type"     = "S3"
    },
    local.tags,
  )
}

resource "aws_s3_object" "object" {
  for_each = fileset("tomcat-new/", "**")

  bucket  = aws_s3_bucket.this.id
  key     = each.value
  content = file("tomcat-new/${each.value}")
}


module "s3" {
  source = "./modules/s3"

  count = local.create_rabbit_ec2 ? 1 : 0

  bucket_name     = local.bucket_name_rabbit
  environment     = local.environment
  fileset         = "rabbit/"
  fileset_content = "rabbit/"
  tags            = local.tags
}

module "s3-elastic" {
  source = "./modules/s3"

  count = local.create_elastic_ec2 ? 1 : 0

  bucket_name     = local.bucket_name_elastic
  environment     = local.environment
  fileset         = "elasticsearch/"
  fileset_content = "elasticsearch/"
  tags            = local.tags
}