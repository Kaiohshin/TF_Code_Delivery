output "instance" {
  value = aws_instance.docker_instance.public_dns
}

output "repository_url" {
  value = aws_ecrpublic_repository.docker_ecr_repo.repository_url
}

output "repository_arn" {
  value = aws_ecrpublic_repository.docker_ecr_repo.arn
}