# Configuração do Terraform ----------------------------------------------------
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
module "ec2" {
    source = "./modules/ec2"
}

module "elb" {
    source = "./modules/elb"  
}

module "network" {
  source = "./modules/network"
} 

module "security" {
    source = "./modules/security"
}
# ------------------------------------------------------------------------------