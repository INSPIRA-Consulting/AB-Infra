terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
    github = {
      source  = "hashicorp/github"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {
  owner = "INSPIRA-Consulting"
  token = var.github_token
}

# Criação automática do Key Pair para acesso SSH
resource "tls_private_key" "main_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main_key_pair" {
  key_name   = "anjos-bolos-low-cost-key"
  public_key = tls_private_key.main_key.public_key_openssh
  
  tags = {
    Name        = "anjos-bolos-low-cost-key"
    Environment = "low-cost"
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.main_key.private_key_pem
  filename        = "${path.module}/keys/anjos-bolos-low-cost-key.pem"
  file_permission = "0400"
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

  # SSH Key Management
  key_pair_name   = aws_key_pair.main_key_pair.key_name
  private_key_pem = tls_private_key.main_key.private_key_pem
}

# Storage (S3 Buckets) - Habilitado para uso da Lambda
module "storage" {
  source = "./modules/storage"
  
  # Configurações gerais
  vpc_id = module.network.vpc_id
}

# Lambda Functions
module "lambda" {
  source = "./modules/lambda"

  # Configurações da Lambda
  s3_bucket_name = module.storage.bucket_raw_name
}

module "github_actions" {
  source = "./modules/github_actions"

  access_key = tls_private_key.main_key.private_key_pem
  private_ip_host = module.instances.private_ip_1a
  public_ip_host = module.instances.public_ip_1a

}