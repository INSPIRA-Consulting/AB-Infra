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
    file("${path.module}/../../scripts/instalar_nginx.sh")
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

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/anjos-bolos-low-cost-key.pem /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "sudo chmod 400 /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "sudo chown ubuntu:ubuntu /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "echo 'Aguardando cloud-init terminar...'",
      "sudo cloud-init status --wait || echo 'Timeout cloud-init'",
      "echo 'Frontend configurado. NGINX será iniciado após backend estar pronto.'"
    ]
  }
}

# Configura NGINX após ambas instâncias estarem prontas
resource "null_resource" "configure_nginx" {
  depends_on = [aws_instance.frontend_1a, aws_instance.backend_1a]

  triggers = {
    frontend_id = aws_instance.frontend_1a.id
    backend_id  = aws_instance.backend_1a.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key_pem
    host        = aws_instance.frontend_1a.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Configurando IP do backend para proxy reverso...'",
      "sed -i 's/PLACEHOLDER_IP_API/${aws_instance.backend_1a.private_ip}:8080/g' /home/ubuntu/nginx-config/default.conf",
      "echo 'IP do backend configurado: ${aws_instance.backend_1a.private_ip}:8080'",
      "cat /home/ubuntu/nginx-config/default.conf",
      "echo 'Verificando se porta 80 está livre...'",
      "sudo lsof -i :80 || echo 'Porta 80 está livre'",
      "echo 'Iniciando NGINX via Docker Compose...'",
      "cd /home/ubuntu && sudo docker compose -f compose.yaml up -d",
      "echo 'Aguardando NGINX iniciar...'",
      "sleep 5",
      "echo 'Verificando containers...'",
      "sudo docker ps",
      "echo 'Testando NGINX localmente...'",
      "curl -I http://localhost:80 || echo 'NGINX ainda não respondeu'",
      "echo 'NGINX Docker iniciado com sucesso!'"
    ]
  }
}
