data "aws_ami" "img" {
  count = var.use_data ? 1 : 0
  
  most_recent = true
  owners      = ["${var.owner}"]

  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }
}

data "aws_availability_zones" "azs" {}

data "aws_subnet" "this" {
  id = var.subnet_id
}