# Configuração das Instâncias EC2 Front-End

resource "aws_instance" "frontend_1a" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = { Name = "Front-End-1a" }

  key_name = var.key_pair_name

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  associate_public_ip_address = true

  vpc_security_group_ids = var.public_security_group_ids

  subnet_id = var.public_subnet_1a_id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    content     = var.private_key_pem
    destination = "/tmp/anjos-bolos-key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/anjos-bolos-key.pem /home/ubuntu/anjos-bolos-key.pem",
      "sudo chmod 400 /home/ubuntu/anjos-bolos-key.pem",
      "sudo chown ubuntu:ubuntu /home/ubuntu/anjos-bolos-key.pem"
    ]
  }
}

resource "aws_instance" "frontend_1b" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = { Name = "Front-End-1b" }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  key_name = var.key_pair_name

  associate_public_ip_address = true

  vpc_security_group_ids = var.public_security_group_ids

  subnet_id = var.public_subnet_1b_id
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    content     = var.private_key_pem
    destination = "/tmp/anjos-bolos-key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/anjos-bolos-key.pem /home/ubuntu/anjos-bolos-key.pem",
      "sudo chmod 400 /home/ubuntu/anjos-bolos-key.pem",
      "sudo chown ubuntu:ubuntu /home/ubuntu/anjos-bolos-key.pem"
    ]
  }
}

