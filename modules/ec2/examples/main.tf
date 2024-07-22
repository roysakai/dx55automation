## EC2
module "ec2" {
  source = "../../ec2"

  name                        = "ec2-terraform"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = "key"
  eip                         = true
  subnet_id                   = "subnet-08f9e069d21a640af"
  image_name                  = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  owner                       = "099720109477"
  encrypted                   = true ### IN CASE OF TRUE AWS WILL DISABLE THE KEY AFTER 30 DAYS. If false it will not encrypt ebs blocks.

  security_group_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "http"
    }
    # Adicione mais regras conforme necessário
  ]

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 10
      tags = {
        Name = "root-block"
      }
    },
  ]

  policy_additional = {
    bucket_s3 = {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:ListMultipartUploadParts",
            "s3:AbortMultipartUpload",
          ],
          Resource = [
            "${module.s3.bucket-arn}/*"
          ],
        },
      ],
    }

    tags = merge(
      {
        Environment = "Development"
      },
      var.tags
    )
  }
}
