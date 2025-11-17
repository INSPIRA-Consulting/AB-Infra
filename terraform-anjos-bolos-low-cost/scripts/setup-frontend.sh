#!/bin/bash
# Script consolidado para configuração do Frontend
set -e
exec > /var/log/frontend-setup.log 2>&1
echo "Iniciando configuração do Frontend - $(date)"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Atualizando sistema..."
apt-get update -y

log "Instalando dependências básicas..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    netcat-openbsd

log "Configurando repositório do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

log "Instalando Docker..."
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

log "Configurando Docker..."
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

log "Instalando Docker Compose..."
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

log "Criando estrutura de diretórios..."
mkdir -p /home/ubuntu/{frontend,nginx-config}
chown -R ubuntu:ubuntu /home/ubuntu

log "Criando página inicial..."
echo "<h1>Frontend - Anjos Bolos</h1><p>Status: Aguardando configuração do proxy...</p>" > /home/ubuntu/frontend/index.html

log "Criando configuração inicial do NGINX..."
cat > /home/ubuntu/nginx-config/default.conf << 'EOF'
server {
    listen 80;
    server_name _;
    
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files $uri $uri/ =404;
    }
    
    # Placeholder para API - será configurado depois
    location /api/ {
        return 503 "Backend não configurado ainda";
        add_header Content-Type text/plain;
    }
    
    location /health {
        return 200 "Frontend OK";
        add_header Content-Type text/plain;
    }
}
EOF

chown ubuntu:ubuntu /home/ubuntu/nginx-config/default.conf

log "Frontend configurado com sucesso!"
log "Serviços prontos: Docker, Docker Compose"
log "Estrutura criada: /home/ubuntu/frontend, /home/ubuntu/nginx-config"