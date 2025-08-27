# Variáveis da VPC --------------------------------------------------------
variable "vpc_cidr_block" { default = "10.25.0.0/26" }
variable "enable_dns_support" { default = false }
variable "enable_dns_hostnames" { default = false }
variable "vpc_name" { default = "vpc-anjos-bolos" }
# -------------------------------------------------------------------------

# Variáveis das Subnets ---------------------------------------------------
variable "public_subnet_1a_cidr" { default = "10.25.0.0/28" }
variable "public_subnet_1b_cidr" { default = "10.25.0.16/28" }

variable "private_subnet_1a_cidr" { default = "10.25.0.32/28" }
variable "private_subnet_1b_cidr" { default = "10.25.0.48/28" }

variable "az_1a" { default = "us-east-1a" }
variable "az_1b" { default = "us-east-1b" }

variable "subnet_pub1a_name" { default = "subnet-pub1a-anjos-bolos" }
variable "subnet_pub1b_name" { default = "subnet-pub1b-anjos-bolos" }

variable "subnet_priv1a_name" { default = "subnet-priv1a-anjos-bolos" }
variable "subnet_priv1b_name" { default = "subnet-priv1b-anjos-bolos" }
# -------------------------------------------------------------------------

# Variáveis do Internet Gateway e Route Tables ----------------------------
variable "igw_name" { default = "igw-anjos-bolos" }

variable "rtb_pub_name" { default = "rtb-pub-anjos-bolos" }

variable "rtb_priv_name" { default = "rtb-priv-anjos-bolos" }

variable "public_route_cidr" { default = "0.0.0.0/0" }
# -------------------------------------------------------------------------