output "backend_security_group_id" {
  description = "ID do Security Group para instâncias backend"
  value       = aws_security_group.sg-back_end-priv.id
}

output "database_security_group_id" {
  description = "ID do Security Group para instâncias de banco de dados"
  value       = aws_security_group.sg-back_end-priv.id
}

output "frontend_security_group_id" {
  description = "ID do Security Group para instâncias frontend"
  value       = aws_security_group.sg-front_end-pub.id
}

output "ssh_public_security_group_id" {
  description = "ID do Security Group SSH público"
  value       = aws_security_group.sg-acesso_remoto-pub.id
}

output "ssh_private_security_group_id" {
  description = "ID do Security Group SSH privado"
  value       = aws_security_group.sg-acesso_remoto-priv.id
}

# Outputs para compatibilidade com main.tf
output "sg_private_ids" {
  description = "IDs dos Security Groups privados"
  value       = [aws_security_group.sg-back_end-priv.id, aws_security_group.sg-acesso_remoto-priv.id]
}

output "sg_public_ids" {
  description = "IDs dos Security Groups públicos"
  value       = [aws_security_group.sg-front_end-pub.id, aws_security_group.sg-acesso_remoto-pub.id]
}

output "public_security_group_id" {
  description = "ID do Security Group público principal"
  value       = aws_security_group.sg-front_end-pub.id
}

output "private_security_group_id" {
  description = "ID do Security Group privado principal"
  value       = aws_security_group.sg-back_end-priv.id
}
