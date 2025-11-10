#!/bin/bash

echo "==================================="
echo "Preparando ambiente para NGINX"
echo "==================================="

# Criando o diretório de html
mkdir -p /home/ubuntu/frontend
chown ubuntu:ubuntu /home/ubuntu/frontend
echo "<h1>Uh papai! NGINX via Docker Compose!</h1>" > /home/ubuntu/frontend/index.html
echo "Página inicial do NGINX criada com sucesso."

# Criando diretório para configurações customizadas do NGINX
mkdir -p /home/ubuntu/nginx-config
chown ubuntu:ubuntu /home/ubuntu/nginx-config

# Criando arquivo de configuração do NGINX com proxy reverso
cat > /home/ubuntu/nginx-config/default.conf << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name localhost;

    # Rota padrão: Serve uma página simples
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }

    # Proxy para /api/* -> backend
    location /api/ {
        proxy_pass http://${IP_PORTA_API}/;
        
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

chown ubuntu:ubuntu /home/ubuntu/nginx-config/default.conf
echo "Configuração do NGINX criada com sucesso em /home/ubuntu/nginx-config/default.conf"

echo "==================================="
echo "Ambiente NGINX preparado!"
echo "==================================="
