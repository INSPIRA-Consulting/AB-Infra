# Configuração das Instâncias EC2 Back-End

resource "aws_instance" "backend_1a" {
  ami           = var.ami_id
  instance_type = var.instance_type_back

  tags = { Name = "Back-End-1a" }

  key_name = var.key_pair_name

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  vpc_security_group_ids = var.private_security_group_ids

  associate_public_ip_address = false

  subnet_id = var.private_subnet_1a_id

  user_data = join("\n\n", [
    "#!/bin/bash",
    file("${path.module}/../../scripts/instalar_docker_ubuntu.sh"),
    templatefile("${path.module}/../../scripts/instalar_java.sh", {
      arquivo_docker_compose = base64encode(file("${path.module}/../../scripts/compose-api.yaml"))
    })
  ])

  user_data_replace_on_change = true
}