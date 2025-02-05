terraform {
   backend "remote" {
    organization = "Dej"

    workspaces {
      name = "TF_Code_Delivery"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}
