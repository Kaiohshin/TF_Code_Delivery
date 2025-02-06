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