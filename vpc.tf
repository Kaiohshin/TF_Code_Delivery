module "docker_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name           = var.environment.name
  cidr           = var.cidr
  azs            = var.azs
  public_subnets = var.public_subnets
  create_igw = true
  
  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}
