# =============================================================================
# CONFIGURAÇÃO DAS INSTÂNCIAS EC2 BACKEND PRIVADAS - Modelo Simplificado
# =============================================================================

resource "aws_instance" "backend_1a" {
  ami           = var.ami_id
  instance_type = var.instance_type_back

  tags = { Name = "Back-End-1a" }

  key_name = var.key_pair_name
  
  # Usando LabInstanceProfile (referência direta)
  iam_instance_profile = "LabInstanceProfile"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    volume_type = "gp3"
  }

  vpc_security_group_ids = var.private_security_group_ids

  associate_public_ip_address = false

  subnet_id = var.private_subnet_1a_id

  # User data otimizado para o novo modelo
  user_data = base64encode(templatefile("${path.module}/../../scripts/setup-backend.sh", {}))

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
    source      = "${path.module}/../../scripts/docker/compose-api.yaml"
    destination = "/home/ubuntu/compose-api.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/docker/compose-rabbit.yaml"
    destination = "/home/ubuntu/compose-rabbit.yaml"
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
    destination = "/home/ubuntu/create_db_backup.py"
  }

  # Provisioner simplificado - aguarda setup e configura
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/*.yaml",
      "chown ubuntu:ubuntu /home/ubuntu/*.yaml /home/ubuntu/create_db_backup.py",
      "echo 'Aguardando backend setup OTIMIZADO terminar...'",
      "timeout 300 bash -c 'while ! grep -q \"Backend OTIMIZADO configurado com sucesso!\" /var/log/backend-setup.log 2>/dev/null; do echo \"Aguardando...\"; sleep 10; done'",
      "sleep 3",
      "echo 'Configurando banco de dados...'", 
      "mysql -u root -proot123 < /tmp/init.sql",
      "mysql -u root -proot123 < /tmp/create_user.sql",
      "echo 'Iniciando serviços Docker...'",
      "cd /home/ubuntu && sudo -u ubuntu docker compose -f compose-api.yaml up -d",
      "sleep 5",
      "cd /home/ubuntu && sudo -u ubuntu docker compose -f compose-rabbit.yaml up -d",
      "echo 'Backend COMPLETO configurado com sucesso!'",
      "rm -f /tmp/*.sql"
    ]
  }
}