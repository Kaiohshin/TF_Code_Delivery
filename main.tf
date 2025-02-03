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

  repository_name = "${var.environment.name}-docker-ecr-repo"

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
  name = "${var.environment.name}-instance"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.docker_vpc.public_subnets
  security_groups           = [aws_security_group.docker_sg.id]
  image_id                  = data.aws_ssm_parameter.my_amzn_linux_ami.value
  instance_type             = var.docker_instance

  iam_instance_profile_name = aws_iam_instance_profile.tf_docker_role.name

  user_data = data.template_file.docker_compose.rendered

  tags = {
    Name = "docker"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "${var.environment.name}-alb"

  load_balancer_type = "application"

  vpc_id          = module.docker_vpc.vpc_id
  subnets         = module.docker_vpc.public_subnets
  security_groups = [aws_security_group.docker_sg.id]

  target_groups = [
    {
      name_prefix      = "${var.environment.name}-"
      backend_protocol = "HTTP"
      backend_port     = 80
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
    Terraform   = "true"
    Environment = var.environment.name
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

module "cloudinit" {
  source  = "tedivm/cloudinit/general"
  version = "~> 1.0"

  runcmd = [
    "sudo yum update -y",
    "sudo yum install -y docker",
    "sudo curl -L [https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)] -o /usr/local/bin/docker-compose",
    "sudo chmod +x /usr/local/bin/docker-compose",
    "sudo systemctl start docker",
    "sudo systemctl enable docker",
    "sudo usermod -a -G docker ec2-user ",
    "sudo chkconfig docker on",
    "sudo chown $(whoami):$(whoami) /var/run/docker.sock",
    "aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 992382655760.dkr.ecr.eu-north-1.amazonaws.com",
    "docker-compose -f /opt/docker-compose.yml up -d"
  ]

  config_files = {
    "/opt/docker-compose.yml" : templatefile("docker-compose.yml")
  }
}