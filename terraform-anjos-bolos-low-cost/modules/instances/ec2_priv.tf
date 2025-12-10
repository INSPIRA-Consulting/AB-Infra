# =============================================================================
# CONFIGURAÇÃO DAS INSTÂNCIAS EC2 BACKEND PRIVADAS - Modelo Simplificado
# =============================================================================

resource "aws_instance" "backend" {
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

  subnet_id = var.private_subnet_id

  # User data otimizado para o novo modelo
  user_data = base64encode(templatefile("${path.module}/../../scripts/setup-backend.sh", {}))

  user_data_replace_on_change = true

  connection {
    type                = "ssh"
    user                = "ubuntu"
    private_key         = var.private_key_pem
    host                = self.private_ip
    bastion_host        = aws_instance.frontend.public_ip
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
    source      = "${path.module}/../../scripts/docker/compose-redis.yaml"
    destination = "/home/ubuntu/compose-redis.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/sql/init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/sql/inserts.sql"
    destination = "/tmp/inserts.sql"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/sql/insert_feriado.sql"
    destination = "/tmp/insert_feriado.sql"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/backup/create_db_backup.py"
    destination = "/home/ubuntu/create_db_backup.py"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/backup/.env"
    destination = "/home/ubuntu/create_db_backup.env"
  }

  # Provisioner simplificado - aguarda setup e configura
  provisioner "remote-exec" {
    inline = [
      "sudo -u ubuntu mkdir -p /home/ubuntu/backup",
      "mv /home/ubuntu/create_db_backup.py /home/ubuntu/backup/create_db_backup.py",
      "mv /home/ubuntu/create_db_backup.env /home/ubuntu/backup/.env",
      "chmod +x /home/ubuntu/*.yaml",
      "chown ubuntu:ubuntu /home/ubuntu/*.yaml",
      "chmod +x /home/ubuntu/backup/create_db_backup.py",
      "chown ubuntu:ubuntu /home/ubuntu/backup/create_db_backup.py",
      "chown ubuntu:ubuntu /home/ubuntu/backup/.env",
      "chmod 600 /home/ubuntu/backup/.env",
      "echo 'Aguardando backend setup OTIMIZADO terminar...'",
      "timeout 300 bash -c 'while ! grep -q \"Backend OTIMIZADO configurado com sucesso!\" /var/log/backend-setup.log 2>/dev/null; do echo \"Aguardando...\"; sleep 10; done'",
      "sleep 3",
      "echo 'Configurando PATH e permissões...'",
      "export PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin\"",
      "echo 'Configurando banco de dados...'", 
      "mysql -u root -proot123 < /tmp/init.sql",
      "mysql -u root -proot123 < /tmp/inserts.sql",
      "mysql -u root -proot123 < /tmp/insert_feriado.sql",
      "echo 'Criando script para iniciar Docker...'",
      "cat > /tmp/start_docker.sh << 'EOF'",
      "#!/bin/bash",
      "export PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"",
      "cd /home/ubuntu",
      "echo \"Iniciando API container...\"",
      "docker-compose -f compose-api.yaml up -d",
      "sleep 5", 
      "echo \"Iniciando RabbitMQ container...\"",
      "docker-compose -f compose-rabbit.yaml up -d",
      "echo \"Iniciando Redis container...\"",
      "docker-compose -f compose-redis.yaml up -d",
      "echo \"Verificando containers...\"",
      "docker ps",
      "EOF",
      "chmod +x /tmp/start_docker.sh",
      "chown ubuntu:ubuntu /tmp/start_docker.sh",
      "echo 'Executando Docker como usuário ubuntu...'",
      "sudo -H -u ubuntu /tmp/start_docker.sh",
      "echo 'Configurando cron para backup diário...'",
      "CRON_ENTRY=\"0 22 * * * cd /home/ubuntu/backup && /opt/python-env/bin/python3 /home/ubuntu/backup/create_db_backup.py >> /home/ubuntu/backup/backup.log 2>&1\"",
      "(crontab -l 2>/dev/null | grep -Fv '/home/ubuntu/backup/create_db_backup.py'; echo \"$CRON_ENTRY\") | crontab -",
      "crontab -l",
      "echo 'Backend COMPLETO configurado com sucesso!'",
      "rm -f /tmp/*.sql /tmp/start_docker.sh"
    ]
  }
}