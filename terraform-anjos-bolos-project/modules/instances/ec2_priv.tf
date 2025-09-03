# TODO: Adicionar o Security Group na EC2

# Configuração das Instâncias EC2 Back-End ------------------------------------------------


resource "aws_instance" "back-end1a" {
  ami           = var.ami_id
  instance_type = var.instance_type_back

  tags = {
    Name = "Back-End-1a"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  # vpc_security_group_ids = [var.backend_security_group_id]

  subnet_id = var.private_subnet_1a_id
}

resource "aws_instance" "back-end1b" {
  ami           = var.ami_id
  instance_type = var.instance_type_back

  tags = {
    Name = "Back-End-1b"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  # vpc_security_group_ids = [var.backend_security_group_id]

  subnet_id = var.private_subnet_1b_id
}


# ------------------------------------------------------------------------------

# Configuração das Instâncias EC2 Banco de Dados ------------------------------------------------

resource "aws_instance" "database1a" {
  ami           = var.ami_id
  instance_type = var.instance_type_db

  tags = {
    Name = "Banco-Dados-1a"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  #vpc_security_group_ids = [var.database_security_group_id]

  subnet_id = var.private_subnet_1a_id
}

resource "aws_instance" "database1b" {
  ami           = var.ami_id
  instance_type = var.instance_type_db

  tags = {
    Name = "Banco-Dados-1b"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  #vpc_security_group_ids = [var.database_security_group_id]

  subnet_id = var.private_subnet_1b_id
}
