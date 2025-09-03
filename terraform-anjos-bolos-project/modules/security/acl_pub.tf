# Configuração das ACLs --------------------------------------
resource "aws_network_acl" "public" {
    vpc_id = var.vpc_id
    tags = { Name = "acl-pub-anjos-bolos" }
}

# ------------------------------------------------------------

# Configuração das Regras da ACL Pública ---------------------
# Entrada - HTTP (80)
resource "aws_network_acl_rule" "public_in_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Entrada - HTTPS (443)
resource "aws_network_acl_rule" "public_in_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Entrada - SSH (22) apenas do IP da confeitaria
resource "aws_network_acl_rule" "public_in_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 130
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.18.32.0/20"
  from_port      = 22
  to_port        = 22
}

# Entrada - Ephemeral Ports (respostas de conexões)
resource "aws_network_acl_rule" "public_in_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 140
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Saída - todo tráfego
resource "aws_network_acl_rule" "public_out_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
# -------------------------------------------------------------

# Associar a ACL pública às subnets públicas ------------------
resource "aws_network_acl_association" "public_a" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = var.public_subnet_1a_id
}

resource "aws_network_acl_association" "public_b" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = var.public_subnet_1b_id
}
# -------------------------------------------------------------
