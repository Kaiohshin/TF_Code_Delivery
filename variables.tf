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

# # Variable for VPC ID
# variable "vpc_id" {
#   description = "ID of the VPC"
#   type        = string
#   default     = "vpc-06dded31d0d4f306b"
# }

# Variable for security group name of Docker
variable "security_group_name" {
  description = "Docker security group name"
  type        = string
  default     = "Docker-security-group"
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

variable "PATH_TO_PRIVATE_KEY" {
  default = "docker-key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "docker-key.pub"
}