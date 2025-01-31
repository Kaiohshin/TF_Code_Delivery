data "template_file" "docker-compose" {
  template = file("docker-compose.tpl")
}

data "aws_ssm_parameter" "my-amzn-linux-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
