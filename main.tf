provider "aws" {
  region = "eu-north-1"
}

terraform {
  required_version = ">= 0.12.0"
}

data "aws_vpc" "default" {
  default = true
}

data "vpc-06dded31d0d4f306b" "all" {
  vpc_id = data.aws_vpc.default.id
}
