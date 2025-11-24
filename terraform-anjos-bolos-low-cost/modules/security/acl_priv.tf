# resource "aws_network_acl" "private" {
#   vpc_id     = var.vpc_id
#   subnet_ids = [var.private_subnet_id]
#   tags       = { Name = "acl-priv-anjos-bolos" }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "10.25.0.0/26"
#     from_port  = 22
#     to_port    = 22
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 110
#     action     = "allow"
#     cidr_block = "10.25.0.0/26"
#     from_port  = 8080
#     to_port    = 8080
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 120
#     action     = "allow"
#     cidr_block = "10.25.0.0/26"
#     from_port  = 8081
#     to_port    = 8081
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 130
#     action     = "allow"
#     cidr_block = "10.25.0.0/26"
#     from_port  = 3306
#     to_port    = 3306
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 140
#     action     = "allow"
#     cidr_block = "10.25.0.0/26"
#     from_port  = 5672
#     to_port    = 5672
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 150
#     action     = "allow"
#     cidr_block = "10.25.0.0/26"
#     from_port  = 15672
#     to_port    = 15672
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 160
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 65535
#   }

#   egress {
#     protocol   = "-1"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
# }