terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "us-east-1"
}
# ------------------------------------------------------------------------------

# Criação automática do Key Pair para acesso SSH
resource "tls_private_key" "main_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main_key_pair" {
  key_name   = "anjos-bolos-key"
  public_key = tls_private_key.main_key.public_key_openssh
  
  tags = {
    Name = "anjos-bolos-key"
    Project = "terraform-anjos-bolos"
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.main_key.private_key_pem
  filename        = "${path.module}/keys/anjos-bolos-key.pem"
  file_permission = "0400"
}

# Módulos ----------------------------------------------------------------------
module "network" {
  source = "./modules/network"
}

module "security" {
  source               = "./modules/security"
  vpc_id               = module.network.vpc_id
  public_subnet_1a_id  = module.network.public_subnet_1a_id
  public_subnet_1b_id  = module.network.public_subnet_1b_id
  private_subnet_1a_id = module.network.private_subnet_1a_id
  private_subnet_1b_id = module.network.private_subnet_1b_id
}

# Criamos as instâncias com as referências das subnets e security groups
module "instances" {
  source = "./modules/instances"

  # Subnets
  private_subnet_1a_id = module.network.private_subnet_1a_id
  private_subnet_1b_id = module.network.private_subnet_1b_id
  public_subnet_1a_id  = module.network.public_subnet_1a_id
  public_subnet_1b_id  = module.network.public_subnet_1b_id

  # Security Groups
  private_security_group_ids = module.security.sg_private_ids
  public_security_group_ids  = module.security.sg_public_ids
  
  # Key Pair
  key_pair_name = aws_key_pair.main_key_pair.key_name
  
  # Chave privada para provisioners
  private_key_pem = tls_private_key.main_key.private_key_pem
}

# Load Balancers com todas as referências necessárias
# module "elb" {
#   source = "./modules/elb"

#   # IDs da VPC e Subnets
#   vpc_id               = module.network.vpc_id
#   public_subnet_1a_id  = module.network.public_subnet_1a_id
#   public_subnet_1b_id  = module.network.public_subnet_1b_id
#   private_subnet_1a_id = module.network.private_subnet_1a_id
#   private_subnet_1b_id = module.network.private_subnet_1b_id

#   # Security Group para o Load Balancer
#   public_security_group_id  = module.security.public_security_group_id
#   private_security_group_id = module.security.private_security_group_id

#   # IDs das instâncias
#   private_instance_1a_id = module.instances.private_instance_1a_id
#   private_instance_1b_id = module.instances.private_instance_1b_id
#   public_instance_1a_id  = module.instances.public_instance_1a_id
#   public_instance_1b_id  = module.instances.public_instance_1b_id
# }

# Storage (S3 Buckets e VPC Endpoints)
# module "storage" {
#   source = "./modules/storage"

#   # Configurações gerais
#   vpc_id = module.network.vpc_id

#   # Route tables para o endpoint VPC
#   private_route_table_ids = module.network.private_route_table_ids
# }
