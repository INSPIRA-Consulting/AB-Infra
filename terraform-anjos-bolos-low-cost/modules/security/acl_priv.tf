# -------------------------------------------------------------------
# Network ACL Privada
# -------------------------------------------------------------------
resource "aws_network_acl" "private" {
  vpc_id = var.vpc_id
  tags   = { Name = "acl-priv-anjos-bolos" }
}

resource "aws_network_acl_rule" "private_in_ssh" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.25.0.0/26"
  from_port      = 22
  to_port        = 22
}


# -------------------------------------------------------------------
# Regras de Entrada (Inbound)
# -------------------------------------------------------------------

# Permitir todo tráfego de resposta (necessário pois NACL é stateless)
resource "aws_network_acl_rule" "private_in_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# -------------------------------------------------------------------
# Regras de Saída (Outbound)
# -------------------------------------------------------------------

# Permitir todo tráfego de saída (para internet via NAT Gateway)
resource "aws_network_acl_rule" "private_out_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# -------------------------------------------------------------------
# Associação da ACL à Subnet Privada
# -------------------------------------------------------------------
resource "aws_network_acl_association" "private_a" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = var.private_subnet_1a_id
}
