# Docker Instance
resource "aws_instance" "docker_instance" {
  ami                    = "ami-0ebfd941bbafe70c6"
  instance_type          = var.docker_instance
  vpc_security_group_ids = [aws_security_group.docker_sg.id]

  #User Data in AWS EC2
  user_data = file("docker_install.sh")

  tags = {
    Name = "Docker Python Flask"
  }
}