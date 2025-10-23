output "backend_instance_ids" {
  description = "IDs das instâncias de backend"
  value       = [aws_instance.backend_1a.id]
}

output "public_instances_ids" {
  description = "IDs de todas as instâncias públicas"
  value       = [aws_instance.frontend_1a.id]
}

output "public_instance_1a_id" {
  description = "ID da instância pública na AZ 1a"
  value       = aws_instance.frontend_1a.id
}

output "private_instance_1a_id" {
  description = "ID da instância privada na AZ 1a"
  value       = aws_instance.backend_1a.id
}

output "public_ip_1a" {
  description = "IP da instância pública na AZ 1a"
  value       = aws_instance.frontend_1a.public_ip
}

output "url_gerenciador_rabbitmq" {
  description = "URL do Management UI do RabbitMQ"
  value       = "http://${aws_instance.frontend_1a.public_ip}:15672"
}