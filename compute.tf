# Docker Instance
#resource "aws_instance" "docker_instance" {
#  ami                    = "ami-053a862cc72bed182"
#  instance_type          = var.docker_instance
#  vpc_security_group_ids = [aws_security_group.docker_sg.id]
#
#  #User Data in AWS EC2
#  user_data = file("docker_install.sh")
#
#  tags = {
#    Name = "Docker Python Flask"
#  }
#}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon/amzn2-ami-kernel-5.10-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "docker_instance" {
  ami           = "ami-053a862cc72bed182"
  instance_type = var.docker_instance

  tags = {
    Name = "Docker"
  }
}