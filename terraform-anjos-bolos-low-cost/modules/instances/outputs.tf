output "public_instance_1a_id" {
  description = "ID da instância pública na AZ 1a"
  value       = aws_instance.frontend_1a.id
}

output "private_instance_1a_id" {
  description = "ID da instância privada na AZ 1a"
  value       = aws_instance.backend_1a.id
}