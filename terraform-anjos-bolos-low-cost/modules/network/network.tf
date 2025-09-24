# Configuração da VPC ----------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = { Name = var.vpc_name }
}

# ------------------------------------------------------------------------------

# Configuração das Subnets -----------------------------------------------------
resource "aws_subnet" "public_1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_1a_cidr

  availability_zone = var.az_1a
  tags              = { Name = var.subnet_pub1a_name }
}

resource "aws_subnet" "private_1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_1a_cidr

  availability_zone = var.az_1a
  tags              = { Name = var.subnet_priv1a_name }
}

# ------------------------------------------------------------------------------

# Configuração do Internet Gateway ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = { Name = var.igw_name }
}

# ------------------------------------------------------------------------------

resource "aws_eip" "nat_gateway_eip_1a" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main_1a" {
  allocation_id = aws_eip.nat_gateway_eip_1a.id
  subnet_id     = aws_subnet.public_1a.id
}


# Configuração da Route Table Pública ------------------------------------------
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main.id

  tags = { Name = var.rtb_pub_name }

  route {
    cidr_block = var.public_route_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.rtb_public.id
}

# ------------------------------------------------------------------------------

# Configuração da Route Table Privada ------------------------------------------
resource "aws_route_table" "rtb_private_1a" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.rtb_priv_name}-1a" }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_1a.id
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.rtb_private_1a.id
}
# ------------------------------------------------------------------------------
