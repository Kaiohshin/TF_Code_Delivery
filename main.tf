data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_filter.name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.ami_filter.owner]
}

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

# ECR
resource "aws_ecr_repository" "docker_ecr_repo" {
  name = var.ecr_repo_name
}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "tf-docker-compose-test1"

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

# DynamoDB
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
    Environment = var.environment.name
  }
}

# # EC2 Instance
# resource "aws_instance" "docker_instance" {
#   ami                    = "ami-053a862cc72bed182"
#   instance_type          = var.docker_instance
#   vpc_security_group_ids = [aws_security_group.docker_sg.id]
  
#   # SSH key
#   key_name = aws_key_pair.docker-key.key_name

#   # Role
#   iam_instance_profile = aws_iam_instance_profile.tf-docker-role.name

#   # User Data in AWS EC2
#   user_data = "${data.template_file.docker-compose.rendered}"

#   tags = {
#     Name = "Docker"
#   }
# }

module "docker_autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.5.2"

  name = "${var.environment.name}-docker"

  min_size            = 0
  max_size            = 1
  vpc_zone_identifier = module.docker_vpc.public_subnets
  target_group_arns   = module.docker_alb.target_group_arns
  security_groups     = [var.docker_sg.security_group_id]
  instance_type       = var.docker_instance
  image_id            = "ami-053a862cc72bed182"

  key_name      = aws_key_pair.docker-key.key_name
  iam_role_name = aws_iam_instance_profile.tf-docker-role.name
  user_data     = "${data.template_file.docker-compose.rendered}"
}

module "docker_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "${var.environment.name}-docker-alb"

  load_balancer_type = "application"

  vpc_id             = module.docker_vpc.vpc_id
  subnets            = module.docker_vpc.public_subnets
  security_groups    = [var.docker_sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "${var.environment.name}-"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = var.environment.name
  }
}