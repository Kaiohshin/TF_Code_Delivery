terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "TF-docker-compose-test1" // Enter Bucket Name

  tags = {
    Name        = "S3 bucket"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}