# Autoscaling group
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.0"
  name    = "${var.environment.name}-instance"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"

  vpc_zone_identifier = module.docker_vpc.public_subnets
  target_group_arns   = module.alb.target_group_arns
  security_groups     = [aws_security_group.docker_sg.id]

  image_id      = data.aws_ssm_parameter.my_amzn_linux_ami.value
  instance_type = var.docker_instance

  iam_instance_profile_name = aws_iam_instance_profile.tf_docker_role.name
  user_data                 = base64encode(data.template_file.docker_compose.rendered)

  tags = {
    Name = "docker"
  }
}
