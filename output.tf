output "instance" {
  value = aws_instance.docker_instance.public_dns
}