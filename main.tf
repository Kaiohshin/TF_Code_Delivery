module "blog_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev"
  cidr = "10.0.0.0/16"

  azs                     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  public_subnets          = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  map_public_ip_on_launch = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "blog" {
  ami           = data.aws_ssm_parameter.my_amzn_linux_ami.value
  instance_type = var.docker_instance
  subnet_id     = module.blog_vpc.public_subnets[0]
  # vpc_security_group_ids = default

  tags = {
    Name = "Learning Terraform"
  }
}
# # EC2 Instance
# resource "aws_instance" "docker_instance" {
#   ami                    = data.aws_ssm_parameter.my_amzn_linux_ami.value
#   instance_type          = var.docker_instance
#   vpc_security_group_ids = [aws_security_group.docker_sg.id]
#   subnet_id              = module.docker_vpc.public_subnets[0]
#   # Role
#   iam_instance_profile = aws_iam_instance_profile.tf_docker_role.name
#   # User Data in AWS EC2
#   user_data = data.template_file.docker_compose.rendered

#   tags = {
#     Name = "docker"
#   }
# }

# module "cloudinit" {
#   source  = "tedivm/cloudinit/general"
#   version = "~> 1.0"

#   runcmd = [
#     "sudo yum update -y",
#     "sudo yum install -y docker",
#     "sudo curl -L [https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)] -o /usr/local/bin/docker-compose",
#     "sudo chmod +x /usr/local/bin/docker-compose",
#     "sudo systemctl start docker",
#     "sudo systemctl enable docker",
#     "sudo usermod -a -G docker ec2-user ",
#     "sudo chkconfig docker on",
#     "sudo chown $(whoami):$(whoami) /var/run/docker.sock",
#     "aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 992382655760.dkr.ecr.eu-north-1.amazonaws.com",
#     "docker-compose -f /opt/docker-compose.yml up -d"
#   ]

#   # config_files = {
#   #   "/opt/docker-compose.yml" : templatefile("${path.module}docker-compose.yml", local.template_vars)
#   #   #"/etc/nomad.d/nomad.hcl" : templatefile("${path.module}/templates/nomad.hcl", local.template_vars),
#   # }
# }
