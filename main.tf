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

# Docker Instance
resource "aws_instance" "docker_instance" {
  ami                    = "ami-053a862cc72bed182"
  instance_type          = var.docker_instance
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  
  # SSH key
  key_name = aws_key_pair.docker-key.key_name

  # Role
  iam_instance_profile = aws_iam_instance_profile.s3-tf-docker-role-instanceprofile.name

  # User Data in AWS EC2
  user_data = file("docker_install.sh")

  tags = {
    Name = "Docker"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "tf-docker-compose-test1" // Enter Bucket Name

  tags = {
    Name        = "tf-docker-compose-test1"
  }
}

module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "tf-docker-table"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

#data "aws_ami" "app_ami" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    values = ["amzn2-ami-kernel-5.10-hvm-*"]
#  }#
#
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#
#  owners = ["137112412989"] # Amazon
#}
#
#resource "aws_instance" "docker_instance" {
#  ami           = "aapp_ami"
#  instance_type = var.docker_instance
#
#User Data in AWS EC2
#  user_data = file("docker_install.sh")
#
#  tags = {
#    Name = "Docker"
#  }
#}