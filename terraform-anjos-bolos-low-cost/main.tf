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

# Módulos ----------------------------------------------------------------------
module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"

  vpc_id               = module.network.vpc_id
  public_subnet_1a_id  = module.network.public_subnet_1a_id
  private_subnet_1a_id = module.network.private_subnet_1a_id
}

# Criamos as instâncias com as referências das subnets e security groups
module "instances" {
  source = "./modules/instances"

  # Subnets
  private_subnet_1a_id = module.network.private_subnet_1a_id
  public_subnet_1a_id  = module.network.public_subnet_1a_id

  # Security Groups
  private_security_group_ids = module.security.sg_private_ids
  public_security_group_ids  = module.security.sg_public_ids
}

# Storage (S3 Buckets e VPC Endpoints)
module "storage" {
  source = "./modules/storage"

  # Configurações gerais
  vpc_id = module.network.vpc_id
}
