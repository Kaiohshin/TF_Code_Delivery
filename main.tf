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
resource "aws_ecr_repository" "docker_ecr_repo" {
  name = var.ecr_repo_name
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

# EC2 Instance
resource "aws_instance" "docker_instance" {
  ami                    = data.aws_ssm_parameters_by_path.ami.values[0]
  instance_type          = var.docker_instance
  vpc_security_group_ids = [aws_security_group.docker_sg.id]

  # SSH key
  key_name = aws_key_pair.docker-key.key_name

  # Role
  iam_instance_profile = aws_iam_instance_profile.tf-docker-role.name

  # User Data in AWS EC2
  user_data = data.template_file.docker-compose.rendered

  tags = {
    Name = "Docker"
  }
}
