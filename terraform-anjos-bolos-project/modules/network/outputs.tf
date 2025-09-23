# Outputs do módulo de rede

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

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

# Route Tables
output "private_route_table_ids" {
  description = "IDs das route tables privadas"
  value       = [aws_route_table.rtb-private-1a.id, aws_route_table.rtb-private-1b.id]
}

output "private_route_table_1a_id" {
  description = "ID da route table privada 1a"
  value       = aws_route_table.rtb-private-1a.id
}

output "private_route_table_1b_id" {
  description = "ID da route table privada 1b"
  value       = aws_route_table.rtb-private-1b.id
}
