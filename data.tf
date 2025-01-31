data "template_file" "docker-compose" {
  template = file("docker-compose.tpl")
  vars = aws_ecr_repository.docker_ecr_repo
}

data "aws_ssm_parameter" "my-amzn-linux-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}