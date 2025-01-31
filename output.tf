# output "instance" {
#   value = aws_instance.docker_instance.public_dns
# }

output "dns_alb" {
  value = docker_alb.dns_name
}
output "repository_url" {
  value = aws_ecr_repository.docker_ecr_repo.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.docker_ecr_repo.arn
}

output "dynamodb_table_arn" {
  value = module.dynamodb_table.dynamodb_table_arn
}