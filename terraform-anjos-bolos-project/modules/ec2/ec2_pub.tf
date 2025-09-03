# TODO: Adicionar o Security Group na EC2

# Configuração das Instâncias EC2 Front-End ------------------------------------------------

resource "aws_instance" "front-end1a" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "Front-End-1a"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  # vpc_security_group_ids = []

  subnet_id = aws_subnet.public-1a.id
}

resource "aws_instance" "front-end1b" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "Front-End-1b"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  # vpc_security_group_ids = []

  subnet_id = aws_subnet.public-1b.id
}

