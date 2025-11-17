#!/bin/bash
# Script otimizado para configuração do Backend
set -e
exec > /var/log/backend-setup.log 2>&1
echo "Iniciando configuração OTIMIZADA do Backend - $(date)"

# Função para logging
log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

log "Configurando MySQL Server (pré-instalação)..."
echo 'mysql-server mysql-server/root_password password root123' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password root123' | debconf-set-selections

log "Atualizando sistema e instalando essenciais..."
apt-get update -y

# Instalação em blocos otimizados para reduzir tempo
log "Instalando ferramentas básicas..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl wget gnupg lsb-release ca-certificates apt-transport-https netcat-openbsd

log "Configurando repositório do Docker (paralelo)..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
wait

log "Atualizando repositórios..."
apt-get update -y

log "Instalando MySQL (otimizado)..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends mysql-server
systemctl enable mysql

log "Instalando Docker (essencial)..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    docker-ce docker-ce-cli containerd.io
systemctl enable docker && systemctl start docker
usermod -aG docker ubuntu

log "Instalando Java 17 (essencial)..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-17-jdk

log "Instalando Python para scripts..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 python3-pip

log "Baixando Docker Compose (paralelo)..."
wget -q -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) &

log "Configuração básica do MySQL..."
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl start mysql

log "Finalizando Docker Compose..."
wait
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

log "Criando estrutura de diretórios..."
mkdir -p /home/ubuntu/{backend,backup} /usr/share/{api,api-email}
chown -R ubuntu:ubuntu /home/ubuntu /usr/share/api /usr/share/api-email

log "Configurando Java environment..."
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> /etc/environment

log "Configurando backup básico..."
cat > /home/ubuntu/create_backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/ubuntu/backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mysqldump -u root -proot123 --all-databases > "$${BACKUP_DIR}/backup_$${TIMESTAMP}.sql" 2>/dev/null || echo "Backup failed"
EOF
chmod +x /home/ubuntu/create_backup.sh
chown ubuntu:ubuntu /home/ubuntu/create_backup.sh

log "Instalando boto3 para scripts..."
pip3 install -q boto3 configparser

log "Backend OTIMIZADO configurado com sucesso!"
log "Serviços: Docker, MySQL, Java 17"
log "Tempo total: $(($(date +%s) - $(stat -c %Y /var/log/backend-setup.log)))s"
log "RabbitMQ será configurado via Docker Compose"