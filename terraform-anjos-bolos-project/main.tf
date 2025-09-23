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
}

# Load Balancers com todas as referências necessárias
module "elb" {
  source = "./modules/elb"

  # IDs da VPC e Subnets
  vpc_id               = module.network.vpc_id
  public_subnet_1a_id  = module.network.public_subnet_1a_id
  public_subnet_1b_id  = module.network.public_subnet_1b_id
  private_subnet_1a_id = module.network.private_subnet_1a_id
  private_subnet_1b_id = module.network.private_subnet_1b_id
 
  # Security Group para o Load Balancer
  public_security_group_id = module.security.public_security_group_id
  private_security_group_id = module.security.private_security_group_id
  
  # IDs das instâncias
  private_instance_1a-id = module.instances.private_instance_1a-id
  private_instance_1b-id = module.instances.private_instance_1b-id

  # Instâncias públicas
  public_instance_1a-id = module.instances.public_instance_1a-id
  public_instance_1b-id = module.instances.public_instance_1b-id
}

# Storage (S3 Buckets e VPC Endpoints)
module "storage" {
  source = "./modules/storage"

  # Configurações gerais
  vpc_id = module.network.vpc_id

  # Route tables para o endpoint VPC
  private_route_table_ids = module.network.private_route_table_ids
}
