output "backend_security_group_id" {
  description = "ID do Security Group para instâncias backend"
  value       = aws_security_group.sg-back_end-priv.id
}

output "database_security_group_id" {
  description = "ID do Security Group para instâncias de banco de dados"
  value       = aws_security_group.sg-back_end-priv.id
}

output "public_security_group_id" {
  description = "ID do Security Group para instâncias públicas"
  value       = aws_security_group.sg-front_end-pub.id
}

output "sg_public_ids" {
  description = "IDs de todas os Security Groups públicos"
  value       = [aws_security_group.sg-front_end-pub.id, aws_security_group.sg-acesso_remoto-pub.id]
}

output "sg_private_ids" {
  description = "IDs de todas os Security Groups privados"
  value       = [aws_security_group.sg-back_end-priv.id, aws_security_group.sg-acesso_remoto-priv.id]
}