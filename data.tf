data "template_file" "docker-compose" {
  template = file("docker-compose.tpl")
}

data "aws_ssm_parameters_by_path" "ami" {
  path = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}
