module "docker_ecr_repo" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${var.environment.name}-docker-ecr-repo"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}
