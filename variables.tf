# Variable for AWS region
variable "region" {
  description = "AWS region"
  default     = "eu-north-1"
}

# Variable for instance type of EC2
variable "docker_instance" {
  description = "Instance type of EC2"
  type        = string
  default     = "t3.micro"
}

# aws ami id
variable "ami_filter" {
  description = "Name filter and owner for AMI"

  type    = object ({
    name  = string
    owner = string
  })

  default = {
    name  = "bitnami-tomcat-*-x86_64-hvm-ebs-nami"
    owner = "979382823631" # Bitnami
  }
}

# Variable for security group name of Docker
variable "security_group_name" {
  description = "Docker security group name"
  type        = string
  default     = "docker_sg"
}

# Variable for Environment
variable "environment" {
  description = "Development Environment"

  type = object({
    name           = string
    network_prefix = string
  })
  
  default = {
  name           = "dev"
  network_prefix = "10.0"
  }
}

# Variable for ECR
variable "ecr_repo_name" {
  description = "ECR Repo Name"
  type        = string
  default     = "docker_ecr_repo"
}

# Variable for DynamoDB
variable "dydb_name" {
  description = "DynamoDB Name"
  type        = string
  default     = "docker_dydb"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "docker-key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "docker-key.pub"
}