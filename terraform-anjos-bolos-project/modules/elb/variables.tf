variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "public_subnet_1a_id" {
  description = "ID da subnet pública na AZ 1a"
  type        = string
}

variable "public_subnet_1b_id" {
  description = "ID da subnet pública na AZ 1b"
  type        = string
}

variable "private_subnet_1a_id" {
  description = "ID da subnet privada na AZ 1a"
  type        = string
}

variable "private_subnet_1b_id" {
  description = "ID da subnet privada na AZ 1b"
  type        = string
}

variable "database_instance_ids" {
  description = "Lista de IDs das instâncias de banco de dados"
  type        = list(string)
}

variable "backend_instance_ids" {
  description = "Lista de IDs das instâncias de backend"
  type        = list(string)
}

# variable "database_security_group_id" {
#   description = "ID do Security Group para o Load Balancer do Database"
#   type        = string
# }

# variable "backend_security_group_id" {
#   description = "ID do Security Group para o Load Balancer do Backend"
#   type        = string
# }

