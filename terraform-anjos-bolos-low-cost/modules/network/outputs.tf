# Outputs do módulo de rede

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

# Subnets Públicas
output "public_subnet_id" {
  description = "ID da subnet pública na AZ 1a"
  value       = aws_subnet.public.id
}

# Subnets Privadas
output "private_subnet_id" {
  description = "ID da subnet privada na AZ 1a"
  value       = aws_subnet.private.id
}

# Route Tables
output "private_route_table_ids" {
  description = "IDs das route tables privadas"
  value       = [aws_route_table.rtb_private.id]
}

output "private_route_table_id" {
  description = "ID da route table privada 1a"
  value       = aws_route_table.rtb_private.id
}
