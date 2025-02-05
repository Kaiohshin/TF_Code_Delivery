# Security group for Docker Instance
resource "aws_security_group" "docker_sg" {
  name        = var.security_group_name
  description = "Allow inbound traffic, SSH"
  vpc_id      = module.docker_vpc.vpc_id
  public

  ingress {
    description = "Allow all HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}
