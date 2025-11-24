output "backend_instance_ids" {
  description = "IDs das instâncias de backend"
  value       = [aws_instance.backend.id]
}

output "public_instances_ids" {
  description = "IDs de todas as instâncias públicas"
  value       = [aws_instance.frontend.id]
}

output "public_instance_id" {
  description = "ID da instância pública na AZ 1a"
  value       = aws_instance.frontend.id
}

output "private_instance_id" {
  description = "ID da instância privada na AZ 1a"
  value       = aws_instance.backend.id
}

output "public_ip" {
  description = "IP da instância pública na AZ 1a"
  value       = aws_instance.frontend.public_ip
}

output "private_ip" {
  description = "IP da instância privada na AZ 1a"
  value = aws_instance.backend.private_ip
}

output "url_gerenciador_rabbitmq" {
  description = "URL do Management UI do RabbitMQ"
  value       = "http://${aws_instance.frontend.public_ip}:15672"
}