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
  default     = "t3.small"
}

variable "private_subnet_1a_id" {
  description = "ID da subnet privada na AZ 1a"
  type        = string
}

variable "public_subnet_1a_id" {
  description = "ID da subnet pública na AZ 1a"
  type        = string
}

variable "private_security_group_ids" {
  description = "ID do Security Group para instâncias privadas"
  type        = list(string)
}

variable "public_security_group_ids" {
  description = "ID do Security Group para instâncias públicas"
  type        = list(string)
}

variable "key_pair_name" {
  description = "Nome do Key Pair para acesso SSH"
  type        = string
}

variable "private_key_pem" {
  description = "Conteúdo da chave privada em formato PEM"
  type        = string
  sensitive   = true
}