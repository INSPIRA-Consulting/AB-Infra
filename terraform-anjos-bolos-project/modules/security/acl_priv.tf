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

# Entrada - Ephemeral ports para respostas da internet
resource "aws_network_acl_rule" "private_in_ephemeral" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 140
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Saída - todo tráfego para a internet
resource "aws_network_acl_rule" "private_out_internal" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "10.25.0.0/26"
  from_port      = 0
  to_port        = 0
  egress         = true
}

resource "aws_network_acl_rule" "private_out_http" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
  egress         = true
}

resource "aws_network_acl_rule" "private_out_https" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 120
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
  egress         = true
}

resource "aws_network_acl_rule" "private_out_dns_tcp" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 130
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
  egress         = true
}

resource "aws_network_acl_rule" "private_out_dns_udp" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 140
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
  egress         = true
}

resource "aws_network_acl_rule" "private_out_ntp" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 150
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 123
  to_port        = 123
  egress         = true
}
# ------------------------------------------------------------

# Associar a ACL privada às subnets privadas
resource "aws_network_acl_association" "private_a" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = var.private_subnet_1a_id
}

resource "aws_network_acl_association" "private_b" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = var.private_subnet_1b_id
}
// -----------------------------------------------------------