# TODO: Adicionar o Security Group na EC2

# Configuração das Instâncias EC2 Back-End ------------------------------------------------


resource "aws_instance" "backend_1a" {
  ami           = var.ami_id
  instance_type = var.instance_type_back

  tags = { Name = "Back-End-1a" }

  key_name = "vockey"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  vpc_security_group_ids = var.private_security_group_ids

  associate_public_ip_address = false

  subnet_id = var.private_subnet_1a_id
}

resource "aws_instance" "backend_1b" {
  ami           = var.ami_id
  instance_type = var.instance_type_back

  tags = { Name = "Back-End-1b" }

  key_name = "vockey"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  vpc_security_group_ids = var.private_security_group_ids

  associate_public_ip_address = false

  subnet_id = var.private_subnet_1b_id
}


# ------------------------------------------------------------------------------

# Configuração das Instâncias EC2 Banco de Dados ------------------------------------------------

resource "aws_instance" "database_1a" {
  ami           = var.ami_id
  instance_type = var.instance_type_db

  tags = { Name = "Banco-Dados-1a" }

  key_name = "vockey"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
    volume_type = "gp3"
  }

  vpc_security_group_ids = var.private_security_group_ids

  associate_public_ip_address = false

  subnet_id = var.private_subnet_1a_id
}

resource "aws_instance" "database_1b" {
  ami           = var.ami_id
  instance_type = var.instance_type_db

  tags = { Name = "Banco-Dados-1b" }

  key_name = "vockey"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
    volume_type = "gp3"
  }

  vpc_security_group_ids = var.private_security_group_ids

  associate_public_ip_address = false

  subnet_id = var.private_subnet_1b_id
}
