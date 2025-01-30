output "instance" {
  value = aws_instance.docker_instance.public_dns
}

output "repository_url" {
  value = aws_ecr_repository.demo_app_ecr_repo.repository_url
}