data "template_file" "docker_compose" {
  template = file("cloud_config.tpl")
  vars = {
    ALPINE_IMAGE = "${module.docker_ecr_repo.repository_url}/dev-docker-ecr-repo:latest",
    REGION       = var.region,
    ECR_URL      = module.docker_ecr_repo.repository_url
  }
}

data "aws_ssm_parameter" "my_amzn_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
