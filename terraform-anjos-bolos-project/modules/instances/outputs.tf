output "backend_instance_ids" {
  description = "IDs das instâncias de backend"
  value       = [aws_instance.back-end1a.id, aws_instance.back-end1b.id]
}

output "public_instances_ids" {
  description = "IDs de todas as instâncias públicas"
  value       = [aws_instance.front-end1a.id, aws_instance.front-end1b.id]
}

output "public_instance_1a-id" {
  description = "ID da instância pública na AZ 1a"
  value       = aws_instance.front-end1a.id
}

output "public_instance_1b-id" {
  description = "ID da instância pública na AZ 1b"
  value       = aws_instance.front-end1b.id
}

output "private_instance_1a-id" {
  description = "ID da instância privada na AZ 1a"
  value       = aws_instance.back-end1a.id
}

output "private_instance_1b-id" {
  description = "ID da instância privada na AZ 1b"
  value       = aws_instance.back-end1b.id
}
