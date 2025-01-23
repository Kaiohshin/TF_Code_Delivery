terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "tf-docker-compose-test1" // Enter Bucket Name

  tags = {
    Name        = "S3 bucket"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}