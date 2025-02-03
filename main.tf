# VPC
module "docker_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name           = var.environment.name
  cidr           = var.cidr
  azs            = var.azs
  public_subnets = var.public_subnets

  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}

# ECR
module "docker_ecr_repo" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = var.ecr_repo_name

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.environment.name}-tf-docker-compose-test1"

  tags = {
    Name = "${var.environment.name}tf-docker-compose-test1"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_crypto_conf" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB
module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = var.dydb_name
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "${var.environment.name}-_instance"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.docker_vpc.public_subnets
  security_groups           = [aws_security_group.docker_sg.id]
  image_id                  = data.aws_ssm_parameter.my_amzn_linux_ami.value
  instance_type             = var.docker_instance

  iam_instance_profile_name = aws_iam_instance_profile.tf_docker_role.name

  tags = {
    Name = "docker"
  }
}


# # EC2 Instance
# resource "aws_instance" "docker_instance" {
#   ami                    = data.aws_ssm_parameter.my_amzn_linux_ami.value
#   instance_type          = var.docker_instance
#   vpc_security_group_ids = [aws_security_group.docker_sg.id]

#   # Role
#   iam_instance_profile = aws_iam_instance_profile.tf_docker_role.name

#   # User Data in AWS EC2
#   user_data = data.template_file.docker_compose.rendered

#   tags = {
#     Name = "docker"
#   }
# }
