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