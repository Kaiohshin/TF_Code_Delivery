module "docker_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                    = var.environment.name
  cidr                    = var.cidr
  azs                     = var.azs
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true

  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}
