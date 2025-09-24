# Configuração da ACL Privada --------------------------------
resource "aws_network_acl" "private" {
  vpc_id = var.vpc_id
  tags   = { Name = "acl-priv-anjos-bolos" }
}
// -----------------------------------------------------------

// Configuração das Regras da ACL Privada --------------------
# Entrada - HTTP (80) da subnet pública
resource "aws_network_acl_rule" "private_in_http" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.25.0.0/26"
  from_port      = 80
  to_port        = 80
}

# Entrada - HTTPS (443) da subnet pública
resource "aws_network_acl_rule" "private_in_https" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.25.0.0/26"
  from_port      = 443
  to_port        = 443
}

# Entrada - SSH (22) da subnet pública
resource "aws_network_acl_rule" "private_in_ssh" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 130
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.25.0.0/26"
  from_port      = 22
  to_port        = 22
}

# Saída - todo tráfego apenas para as subnets públicas
resource "aws_network_acl_rule" "private_out_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "10.25.0.0/26"
}
# ------------------------------------------------------------

# Associar a ACL privada às subnets privadas
resource "aws_network_acl_association" "private_a" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = var.private_subnet_1a_id
}
// -----------------------------------------------------------