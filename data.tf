data "template_file" "docker_compose" {
  template = file("docker_compose.tpl")
  # vars     = module.docker_ecr_repo.repository_url
}

data "aws_ssm_parameter" "my_amzn_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
