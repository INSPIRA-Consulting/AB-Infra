# -------------------- Outputs --------------------

# Subnets Públicas
output "public_subnet_1a_id" {
  description = "ID da subnet pública na AZ 1a"
  value       = aws_subnet.public-1a.id
}

output "public_subnet_1b_id" {
  description = "ID da subnet pública na AZ 1b"
  value       = aws_subnet.public-1b.id
}

# Subnets Privadas
output "private_subnet_1a_id" {
  description = "ID da subnet privada na AZ 1a"
  value       = aws_subnet.private-1a.id
}

output "private_subnet_1b_id" {
  description = "ID da subnet privada na AZ 1b"
  value       = aws_subnet.private-1b.id
}
