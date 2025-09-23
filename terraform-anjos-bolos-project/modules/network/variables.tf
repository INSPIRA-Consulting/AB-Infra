# Variáveis da VPC --------------------------------------------------------
variable "vpc_cidr_block" {
  default     = "10.25.0.0/26"
  description = "Bloco CIDR para a VPC"
}

variable "vpc_name" {
  default     = "vpc-anjos-bolos"
  description = "Nome da VPC"
}
# -------------------------------------------------------------------------

# Variáveis das Subnets ---------------------------------------------------
variable "public_subnet_1a_cidr" {
    default     = "10.25.0.0/28"
    description = "Bloco CIDR para a subnet pública 1a"
}

variable "public_subnet_1b_cidr" {
    default     = "10.25.0.16/28"
    description = "Bloco CIDR para a subnet pública 1b"
}

variable "private_subnet_1a_cidr" {
    default     = "10.25.0.32/28"
    description = "Bloco CIDR para a subnet privada 1a"
}

variable "private_subnet_1b_cidr" {
    default     = "10.25.0.48/28"
    description = "Bloco CIDR para a subnet privada 1b"
}

variable "az_1a" {
    default     = "us-east-1a"
    description = "Zona de disponibilidade 1a"
}

variable "az_1b" {
    default     = "us-east-1b"
    description = "Zona de disponibilidade 1b"
}

variable "subnet_pub1a_name" {
    default     = "subnet-pub1a-anjos-bolos"
    description = "Nome da subnet pública 1a"
}

variable "subnet_pub1b_name" {
    default     = "subnet-pub1b-anjos-bolos"
    description = "Nome da subnet pública 1b"
}

variable "subnet_priv1a_name" {
    default     = "subnet-priv1a-anjos-bolos"
    description = "Nome da subnet privada 1a"
}

variable "subnet_priv1b_name" {
    default     = "subnet-priv1b-anjos-bolos"
    description = "Nome da subnet privada 1b"
}
# -------------------------------------------------------------------------

# Variáveis do Internet Gateway e Route Tables ----------------------------
variable "igw_name" {
    default     = "igw-anjos-bolos"
    description = "Nome do Internet Gateway"
}

variable "rtb_pub_name" {
    default     = "rtb-pub-anjos-bolos"
    description = "Nome da tabela de roteamento pública"
}

variable "rtb_priv_name" {
    default     = "rtb-priv-anjos-bolos"
    description = "Nome da tabela de roteamento privada"
}

variable "public_route_cidr" {
    default     = "0.0.0.0/0"
    description = "Bloco CIDR para rota pública"
}
# -------------------------------------------------------------------------

