# Docker Instance
resource "aws_instance" "docker_instance" {
    most_recent = true

  filter {
    name   = "name"
    values = ["amazon/amzn2-ami-kernel-5.10-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

  #User Data in AWS EC2
  user_data = file("docker_install.sh")

  tags = {
    Name = "Docker"
  }
}