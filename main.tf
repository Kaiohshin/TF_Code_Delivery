# VPC
module "docker_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.environment.name
  cidr = "${var.environment.network_prefix}.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  public_subnets  = ["${var.environment.network_prefix}.101.0/24", "${var.environment.network_prefix}.102.0/24", "${var.environment.network_prefix}.103.0/24"]

  tags = {
    Terraform = "true"
    Environment = var.environment.name
  }
}

data "template_file" "docker-compose" {
    template = "${file("docker-compose.tpl")}"
}

# Docker Instance
resource "aws_instance" "docker_instance" {
  ami                    = "ami-053a862cc72bed182"
  instance_type          = var.docker_instance
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  
  # SSH key
  key_name = aws_key_pair.docker-key.key_name

  # Role
  iam_instance_profile = aws_iam_instance_profile.tf-docker-role.name

  # User Data in AWS EC2
  # user_data = file("docker_install.sh")
  user_data = "${data.template_file.docker-compose.rendered}"
  # user_data = module.container-server.cloud_config

  tags = {
    Name = "Docker"
  }
}

resource "aws_ecr_repository" "docker_ecr_repo" {
  name = var.ecr_repo_name
}

resource "aws_s3_bucket" "bucket" {
  bucket = "tf-docker-compose-test1" // Enter Bucket Name

  tags = {
    Name        = "tf-docker-compose-test1"
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

module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

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
    Environment = var.environment
  }
}