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

  user_data = join("\n\n", [
    "#!/bin/bash",
    file("${path.module}/../../scripts/instalar_docker_ubuntu.sh"),
    file("${path.module}/../../scripts/instalar_nginx.sh"),
    file("${path.module}/../../scripts/instalar_rabbitmq_ubuntu.sh")
  ])

  user_data_replace_on_change = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    content     = var.private_key_pem
    destination = "/tmp/anjos-bolos-low-cost-key.pem"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/compose-nginx.yaml"
    destination = "/home/ubuntu/compose.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/compose-rabbitmq.yaml"
    destination = "/home/ubuntu/compose-rabbitmq.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/anjos-bolos-low-cost-key.pem /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "sudo chmod 400 /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "sudo chown ubuntu:ubuntu /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "echo 'Aguardando cloud-init terminar...'",
      "sudo cloud-init status --wait || echo 'Timeout cloud-init'",
      "echo 'Verificando arquivos Docker Compose...'",
      "ls -la /home/ubuntu/compose*.yaml",
      "echo 'Iniciando RabbitMQ via Docker Compose...'",
      "cd /home/ubuntu && sudo docker compose -f compose-rabbitmq.yaml up -d",
      "echo 'Verificando containers...'",
      "sudo docker ps",
      "echo 'RabbitMQ Docker iniciado com sucesso!'"
    ]
  }
}