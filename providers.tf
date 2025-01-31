terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      region = var.region
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}