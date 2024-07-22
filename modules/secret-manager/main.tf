resource "aws_secretsmanager_secret" "this" {
  name_prefix = "database/${var.name}/master-"
  description = "Master account password on ${var.name}"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = var.username
    password = random_password.this.result
  })  
}
resource "random_password" "this" {
  length           = 21
  special          = false
  override_special = "#$%*+[]{}<>"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 0
  numeric          = true
}