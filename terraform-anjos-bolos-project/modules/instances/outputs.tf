output "backend_instance_ids" {
  description = "IDs das instâncias de backend"
  value       = [aws_instance.backend_1a.id, aws_instance.backend_1b.id]
}

output "public_instances_ids" {
  description = "IDs de todas as instâncias públicas"
  value       = [aws_instance.frontend_1a.id, aws_instance.frontend_1b.id]
}

output "public_instance_1a_id" {
  description = "ID da instância pública na AZ 1a"
  value       = aws_instance.frontend_1a.id
}

output "public_instance_1b_id" {
  description = "ID da instância pública na AZ 1b"
  value       = aws_instance.frontend_1b.id
}

output "private_instance_1a_id" {
  description = "ID da instância privada na AZ 1a"
  value       = aws_instance.backend_1a.id
}

output "private_instance_1b_id" {
  description = "ID da instância privada na AZ 1b"
  value       = aws_instance.backend_1b.id
}

output "public_ip_1a" {
  description = "IP da instância pública na AZ 1a"
  value       = aws_instance.frontend_1a.public_ip
}

output "public_ip_1b" {
  description = "IP da instância pública na AZ 1b"
  value       = aws_instance.frontend_1b.public_ip
}
