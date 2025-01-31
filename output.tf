output "instance" {
  value = aws_instance.docker_instance.public_dns
}

output "repository_url" {
  value = aws_ecr_repository.docker_ecr_repo.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.docker_ecr_repo.arn
}

output "dynamodb_table_arn" {
  value = dynamodb_table.docker_dydb.arn
}