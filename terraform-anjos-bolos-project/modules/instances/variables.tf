variable "ami_id" { 
  description = "ID da AMI para as instâncias"
  type        = string
  default     = "ami-020cba7c55df1f615" 
}

variable "instance_type_front" { 
  description = "Tipo de instância para o frontend"
  type        = string
  default     = "t2.micro" 
}

variable "instance_type_back" { 
  description = "Tipo de instância para o backend"
  type        = string
  default     = "t2.micro" 
}

variable "instance_type_db" { 
  description = "Tipo de instância para o banco de dados"
  type        = string
  default     = "t2.micro"
}

variable "private_subnet_1a_id" {
  description = "ID da subnet privada na AZ 1a"
  type        = string
}

variable "private_subnet_1b_id" {
  description = "ID da subnet privada na AZ 1b"
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

# variable "backend_security_group_id" {
#   description = "ID do Security Group para instâncias backend"
#   type        = string
# }

# variable "database_security_group_id" {
#   description = "ID do Security Group para instâncias de banco de dados"
#   type        = string
# }