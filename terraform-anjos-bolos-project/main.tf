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
module "network" {
  source = "./modules/network"
} 

module "security" {
    source = "./modules/security"
    vpc_id              = module.network.vpc_id
    public_subnet_1a_id = module.network.public_subnet_1a_id
    public_subnet_1b_id = module.network.public_subnet_1b_id
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
    
    # # Security Groups
    # backend_security_group_id  = module.security.backend_security_group_id
    # database_security_group_id = module.security.database_security_group_id
}

# module "elb" {
#     source = "./modules/elb"
#     public_subnet_1a_id = module.network.public_subnet_1a_id
#     public_subnet_1b_id = module.network.public_subnet_1b_id
#     vpc_id              = module.network.vpc_id
# }
# ------------------------------------------------------------------------------