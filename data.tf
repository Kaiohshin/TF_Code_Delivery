data "template_file" "docker_compose" {
  template = file("docker-compose.yml")
  # vars     = module.docker_ecr_repo.repository_url
}

data "aws_ssm_parameter" "my_amzn_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
