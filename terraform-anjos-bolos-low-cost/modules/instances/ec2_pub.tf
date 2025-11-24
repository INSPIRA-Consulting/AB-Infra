# Configuração das Instâncias EC2 Front-End

resource "aws_instance" "frontend" {
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

  subnet_id = var.public_subnet_id

  user_data = base64encode(templatefile("${path.module}/../../scripts/setup-frontend.sh", {}))

  user_data_replace_on_change = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    content     = var.private_key_pem
    destination = "/home/ubuntu/anjos-bolos-low-cost-key.pem"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/docker/compose-nginx.yaml"
    destination = "/home/ubuntu/compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/anjos-bolos-low-cost-key.pem",
      "chown ubuntu:ubuntu /home/ubuntu/anjos-bolos-low-cost-key.pem /home/ubuntu/compose.yaml",
      "echo 'Aguardando frontend setup terminar...'",
      "tail -f /var/log/frontend-setup.log | grep -q 'Frontend configurado com sucesso!' || timeout 180 tail -f /var/log/frontend-setup.log",
      "echo 'Iniciando NGINX via Docker Compose...'",
      "cd /home/ubuntu && sudo -u ubuntu docker compose -f compose.yaml up -d",
      "echo 'Frontend Docker iniciado com sucesso!'"
    ]
  }
}

# Configuração otimizada do proxy reverso
resource "terraform_data" "configure_nginx_proxy" {
  depends_on = [aws_instance.frontend, aws_instance.backend]

  triggers_replace = {
    frontend_id = aws_instance.frontend.id
    backend_id  = aws_instance.backend.id
    backend_ip  = aws_instance.backend.private_ip
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key_pem
    host        = aws_instance.frontend.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Preparando configuração do proxy reverso para backend ${aws_instance.backend.private_ip}:8080 (apenas configuração)'",
      "sudo -u ubuntu mkdir -p /home/ubuntu/nginx-config",
      "sudo -u ubuntu cat > /home/ubuntu/nginx-config/default.conf << 'EOL'",
      "server {",
      "    listen 80;",
      "    server_name _;",
      "    location / {",
      "        root /usr/share/nginx/html;",
      "        index index.html index.htm;",
      "        try_files \\$uri \\$uri/ =404;",
      "    }",
      "    location /api/ {",
      "        proxy_pass http://${aws_instance.backend.private_ip}:8080;",
      "        proxy_set_header Host \\$host;",
      "        proxy_set_header X-Real-IP \\$remote_addr;",
      "        proxy_set_header X-Forwarded-For \\$proxy_add_x_forwarded_for;",
      "        proxy_set_header X-Forwarded-Proto \\$scheme;",
      "        proxy_connect_timeout 30s;",
      "        proxy_send_timeout 30s;",
      "        proxy_read_timeout 30s;",
      "    }",
      "    location /email/ {",
      "        proxy_pass http://${aws_instance.backend.private_ip}:8081;",
      "        proxy_set_header Host \\$host;",
      "        proxy_set_header X-Real-IP \\$remote_addr;",
      "        proxy_set_header X-Forwarded-For \\$proxy_add_x_forwarded_for;",
      "        proxy_set_header X-Forwarded-Proto \\$scheme;",
      "        proxy_connect_timeout 30s;",
      "        proxy_send_timeout 30s;",
      "        proxy_read_timeout 30s;",
      "    }",
      "    location /health {",
      "        return 200 'Frontend OK - Backend: ${aws_instance.backend.private_ip}:8080';",
      "        add_header Content-Type text/plain;",
      "    }",
      "}",
      "EOL",
      "echo 'Configuração do proxy criada. Reinicie o NGINX quando o backend estiver ativo.'"
    ]
  }
}
