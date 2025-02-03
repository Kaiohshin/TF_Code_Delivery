# Variable for AWS region
variable "region" {
  description = "AWS region"
  default     = "eu-north-1"
}
variable "cidr" {
  default = "10.0.0.0/16"
  type    = string
}

variable "public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  type    = list(string)
}

variable "azs" {
  default = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  type    = list(string)
}

# Variable for instance type of EC2
variable "docker_instance" {
  description = "Instance type of EC2"
  type        = string
  default     = "t3.micro"
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
