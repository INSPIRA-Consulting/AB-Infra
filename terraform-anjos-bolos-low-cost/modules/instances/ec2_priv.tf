# Configuração das Instâncias EC2 Back-End

resource "aws_instance" "backend_1a" {
  ami           = var.ami_id
  instance_type = var.instance_type_back

  tags = { Name = "Back-End-1a" }

  key_name = var.key_pair_name
  
  # Usando LabRole via data source (mesma abordagem das Lambdas)
  iam_instance_profile = "LabInstanceProfile"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  vpc_security_group_ids = var.private_security_group_ids

  associate_public_ip_address = false

  subnet_id = var.private_subnet_1a_id

  user_data = <<-EOF
    #!/bin/bash
    echo "Instância backend iniciada, aguardando provisioners..."
    # Instalar cloud-init status check
    cloud-init status --wait || echo "Cloud-init concluído"
    EOF

  user_data_replace_on_change = true

  connection {
    type                = "ssh"
    user                = "ubuntu"
    private_key         = var.private_key_pem
    host                = self.private_ip
    bastion_host        = aws_instance.frontend_1a.public_ip
    bastion_user        = "ubuntu"
    bastion_private_key = var.private_key_pem
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/install_scripts/instalar_docker_ubuntu.sh"
    destination = "/tmp/instalar_docker_ubuntu.sh"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/install_scripts/instalar_java.sh"
    destination = "/tmp/instalar_java.sh"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/install_scripts/instalar_mysql_ubuntu.sh"
    destination = "/tmp/instalar_mysql_ubuntu.sh"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/install_scripts/instalar_rabbitmq.sh"
    destination = "/tmp/instalar_rabbitmq.sh"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/docker/compose-api.yaml"
    destination = "/tmp/compose-api.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/docker/compose-rabbit.yaml"
    destination = "/tmp/compose-rabbit.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/sql/init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/sql/create_user.sql"
    destination = "/tmp/create_user.sql"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/backup/create_db_backup.py"
    destination = "/tmp/create_db_backup.py"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/backup/configurar_backup.sh"
    destination = "/tmp/configurar_backup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/instalar_docker_ubuntu.sh",
      "chmod +x /tmp/instalar_java.sh", 
      "chmod +x /tmp/instalar_mysql_ubuntu.sh",
      "chmod +x /tmp/instalar_rabbitmq.sh",
      "chmod +x /tmp/configurar_backup.sh",
      "sudo /tmp/instalar_docker_ubuntu.sh",
      "sudo /tmp/instalar_java.sh",
      "sudo /tmp/instalar_mysql_ubuntu.sh", 
      "sudo /tmp/instalar_rabbitmq.sh",
      "sudo /tmp/configurar_backup.sh"
    ]
  }
}