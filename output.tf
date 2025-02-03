# output "instance" {
#   value = module.asg.
# }

output "dynamodb_table_arn" {
  value = module.dynamodb_table.dynamodb_table_arn
}

output "ecr_url" {
  value = module.docker_ecr_repo.repository_url
}