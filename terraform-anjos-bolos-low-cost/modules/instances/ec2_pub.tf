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
    file("${path.module}/../../scripts/install_scripts/instalar_docker_ubuntu.sh"),
    file("${path.module}/../../scripts/install_scripts/instalar_nginx.sh")
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
    source      = "${path.module}/../../scripts/docker/compose-nginx.yaml"
    destination = "/home/ubuntu/compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/anjos-bolos-low-cost-key.pem /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "sudo chmod 400 /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "sudo chown ubuntu:ubuntu /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "echo 'Aguardando cloud-init terminar...'",
      "sudo cloud-init status --wait || echo 'Timeout cloud-init'",
      "echo 'Frontend configurado. NGINX será iniciado via Docker Compose.'",
      "echo 'Iniciando NGINX via Docker Compose...'",
      "cd /home/ubuntu && sudo docker compose -f compose.yaml up -d",
      "echo 'Aguardando NGINX iniciar...'",
      "sleep 10",
      "echo 'Verificando containers...'",
      "sudo docker ps",
      "echo 'Testando NGINX localmente...'",
      "curl -I http://localhost:80 || echo 'NGINX ainda não respondeu'",
      "echo 'NGINX Docker iniciado com sucesso!'"
    ]
  }
}

# Configuração específica do proxy reverso após ambas instâncias estarem prontas
resource "terraform_data" "configure_nginx_proxy" {
  depends_on = [aws_instance.frontend_1a, aws_instance.backend_1a]

  triggers_replace = {
    frontend_id = aws_instance.frontend_1a.id
    backend_id  = aws_instance.backend_1a.id
    backend_ip  = aws_instance.backend_1a.private_ip
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key_pem
    host        = aws_instance.frontend_1a.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Configurando proxy reverso para backend ${aws_instance.backend_1a.private_ip}:8080'",
      "echo 'Aguardando backend estar disponível...'",
      "timeout 300 bash -c 'until nc -z ${aws_instance.backend_1a.private_ip} 8080; do echo \"Aguardando backend...\"; sleep 10; done' || echo 'Timeout aguardando backend'",
      "echo 'Backend disponível, atualizando configuração do NGINX...'",
      "sudo docker stop frontend_nginx || echo 'Container não estava rodando'",
      "sed -i 's/\\$\\{IP_PORTA_API\\}/${aws_instance.backend_1a.private_ip}:8080/g' /home/ubuntu/nginx-config/default.conf",
      "echo 'IP do backend configurado: ${aws_instance.backend_1a.private_ip}:8080'",
      "cat /home/ubuntu/nginx-config/default.conf | grep -A 5 -B 5 proxy_pass",
      "echo 'Reiniciando NGINX com configuração atualizada...'",
      "cd /home/ubuntu && sudo docker compose -f compose.yaml up -d",
      "sleep 5",
      "echo 'Verificando containers após reconfiguração...'",
      "sudo docker ps",
      "echo 'Testando proxy reverso...'",
      "curl -I http://localhost:80/api/ || echo 'Proxy reverso ainda não respondeu'",
      "echo 'NGINX configurado com sucesso para backend ${aws_instance.backend_1a.private_ip}:8080'"
    ]
  }
}
