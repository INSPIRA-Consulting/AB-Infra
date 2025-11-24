# Configuração da VPC ----------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# ------------------------------------------------------------------------------

# Configuração das Subnets -----------------------------------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  availability_zone = var.az_1a
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  availability_zone = var.az_1a
}
# ------------------------------------------------------------------------------

# Configuração do Internet Gateway ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

}

# ------------------------------------------------------------------------------

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.igw]
}

# Configuração da Route Table Pública ------------------------------------------
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block = var.public_route_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rtb_public.id
}

# ------------------------------------------------------------------------------

# Configuração da Route Table Privada ------------------------------------------
resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rtb_private.id
}
# ------------------------------------------------------------------------------
