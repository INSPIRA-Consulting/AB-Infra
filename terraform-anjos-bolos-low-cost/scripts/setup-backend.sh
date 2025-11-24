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
usermod -aG sudo ubuntu

# Garantir que as permissões do docker.sock estejam corretas
chown root:docker /var/run/docker.sock
chmod 660 /var/run/docker.sock

log "Testando acesso ao Docker..."
# Testar se o Docker está funcionando corretamente
if systemctl is-active --quiet docker; then
    log "Docker está rodando corretamente"
else
    log "ERRO: Docker não está rodando"
    systemctl status docker
fi

log "Instalando Java 17 (essencial)..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-17-jdk

log "Instalando Python para scripts..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 python3-pip python3-venv python3-full

log "Baixando Docker Compose (paralelo)..."
wget -q -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) &

log "Configuração básica do MySQL..."
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

log "Finalizando Docker Compose..."
wait
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

log "Criando estrutura de diretórios..."
mkdir -p /home/ubuntu/{backend,backup} /usr/share/{api,api-email}
chown -R ubuntu:ubuntu /home/ubuntu /usr/share/api /usr/share/api-email

log "Configurando Java environment..."
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> /etc/environment

log "Configurando PATH do sistema..."
# Garantir que o PATH inclui os diretórios essenciais
echo 'export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/python-env/bin"' >> /etc/environment

# Atualizar PATH para a sessão atual
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/python-env/bin"

# Configurar PATH no perfil do ubuntu
echo 'export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/python-env/bin"' >> /home/ubuntu/.bashrc
echo 'export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/python-env/bin"' >> /home/ubuntu/.profile

# Configurar PATH para sessões SSH não-interativas
echo 'export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/python-env/bin"' >> /home/ubuntu/.ssh/environment 2>/dev/null || true

# Criar arquivo .ssh se não existir e configurar PATH
mkdir -p /home/ubuntu/.ssh
chown ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
echo 'export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/python-env/bin"' > /home/ubuntu/.ssh/environment
chown ubuntu:ubuntu /home/ubuntu/.ssh/environment

# Habilitar SSH AcceptEnv para PATH
grep -q "AcceptEnv.*PATH" /etc/ssh/sshd_config || echo "AcceptEnv PATH" >> /etc/ssh/sshd_config

log "Configurando backup básico..."
cat > /home/ubuntu/create_backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/ubuntu/backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mysqldump -u root -proot123 --all-databases > "$BACKUP_DIR/backup_$TIMESTAMP.sql" 2>/dev/null || echo "Backup failed"

# Se o script Python estiver disponível, usar ele também
if [ -f "/opt/python-env/bin/python3" ] && [ -f "/home/ubuntu/backup/create_db_backup.py" ]; then
    cd /home/ubuntu/backup
    /opt/python-env/bin/python3 create_db_backup.py >> /var/log/python-backup.log 2>&1 || echo "Python backup script failed"
fi
EOF
chmod +x /home/ubuntu/create_backup.sh
chown ubuntu:ubuntu /home/ubuntu/create_backup.sh

log "Configurando ambiente Python e instalando boto3..."
# Criar ambiente virtual para evitar conflitos do sistema
python3 -m venv /opt/python-env
/opt/python-env/bin/pip install --upgrade pip
/opt/python-env/bin/pip install boto3 configparser

# Criar link simbólico para facilitar uso
ln -sf /opt/python-env/bin/python3 /usr/local/bin/python-env
ln -sf /opt/python-env/bin/pip /usr/local/bin/pip-env

# Atualizar PATH para scripts
echo 'export PATH="/opt/python-env/bin:$PATH"' >> /etc/environment

# Configurar permissões dos arquivos de perfil
chown ubuntu:ubuntu /home/ubuntu/.bashrc /home/ubuntu/.profile

log "Backend OTIMIZADO configurado com sucesso!"
log "Serviços: Docker, MySQL, Java 17"
log "Tempo total: $(($(date +%s) - $(stat -c %Y /var/log/backend-setup.log)))s"
log "RabbitMQ será configurado via Docker Compose"
log ""
log "IMPORTANTE: Para usar Docker, execute:"
log "  source ~/.bashrc  # ou faça logout/login"
log "  newgrp docker     # para ativar o grupo docker"
log "Verificação: docker ps"
log "PATH configurado: $PATH"