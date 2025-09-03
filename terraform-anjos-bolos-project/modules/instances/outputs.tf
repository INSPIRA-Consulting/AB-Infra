output "backend_instance_ids" {
  description = "IDs das instâncias de backend"
  value       = [aws_instance.back-end1a.id, aws_instance.back-end1b.id]
}

output "database_instance_ids" {
  description = "IDs das instâncias de banco de dados"
  value       = [aws_instance.database1a.id, aws_instance.database1b.id]
}
