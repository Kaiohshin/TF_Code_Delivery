output "dynamodb_table_arn" {
  value = module.dynamodb_table.dynamodb_table_arn
}

output "ecr_url" {
  value = module.docker_ecr_repo.repository_url
}

output "ecr_arn" {
  value = module.docker_ecr_repo.repository_arn
}
