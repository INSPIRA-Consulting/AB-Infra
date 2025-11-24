#!/bin/bash

echo "==================================="
echo "Configurando sistema de backup"
echo "==================================="

# Instala Python 3.12 e dependências
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.12 python3.12-pip python3.12-venv

# Instala AWS CLI v2
echo "Instalando AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install -y unzip
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Instala dependências Python para backup
sudo python3.12 -m pip install boto3 pika

# Cria diretório para scripts de backup
sudo mkdir -p /opt/backup
sudo chown ubuntu:ubuntu /opt/backup

# Move o script de backup para o local definitivo
sudo mv /tmp/create_db_backup.py /opt/backup/create_db_backup.py
sudo chmod +x /opt/backup/create_db_backup.py
sudo chown ubuntu:ubuntu /opt/backup/create_db_backup.py

# Cria arquivo de configuração .env
cat > /opt/backup/.env << 'EOF'
# Configurações do Banco de Dados
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=root123
DB_NAME=anjos_bolos

# Configurações de Backup
BACKUP_DIR=/opt/backup/files
LOG_FILE=/opt/backup/backup.log
REMOVE_LOCAL_AFTER_UPLOAD=1

# Configurações AWS S3 (credenciais via IAM Role)
S3_BUCKET=anjos-bolos-backup
AWS_DEFAULT_REGION=us-east-1

# Configurações RabbitMQ
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5673
RABBITMQ_USER=myuser
RABBITMQ_PASSWORD=secret
RABBITMQ_EXCHANGE=backup.fanout.exchange
EOF

sudo chown ubuntu:ubuntu /opt/backup/.env
sudo chmod 600 /opt/backup/.env

# Cria diretório para arquivos de backup
sudo mkdir -p /opt/backup/files
sudo chown ubuntu:ubuntu /opt/backup/files

echo "==================================="
echo "Configurando cron job para backup"
echo "==================================="

# Remove cron jobs existentes para backup (se houver)
crontab -l 2>/dev/null | grep -v "create_db_backup.py" | crontab -

# Adiciona novo cron job (22:00 todos os dias)
(crontab -l 2>/dev/null; echo "0 22 * * * cd /opt/backup && /usr/bin/python3.12 /opt/backup/create_db_backup.py >> /opt/backup/backup.log 2>&1") | crontab -

echo "Cron job configurado:"
crontab -l | grep "create_db_backup.py"

echo "==================================="
echo "Verificando credenciais AWS"
echo "==================================="

# Aguarda um momento para as credenciais IAM estarem disponíveis
sleep 10

# Testa conexão com AWS
echo "Testando acesso ao S3..."
aws s3 ls s3://anjos-bolos-backup || echo "Bucket ainda não acessível (será criado pelo Terraform)"

# Verifica identidade AWS
echo "Identidade AWS atual:"
aws sts get-caller-identity || echo "Aguardando credenciais IAM..."

echo "==================================="
echo "Testando script de backup"
echo "==================================="

# Executa teste do script de backup
cd /opt/backup && /usr/bin/python3.12 /opt/backup/create_db_backup.py

echo "==================================="
echo "Sistema de backup configurado com sucesso!"
echo "Local do script: /opt/backup/create_db_backup.py"
echo "Configuração: /opt/backup/.env"
echo "Logs: /opt/backup/backup.log"
echo "Cron: Executa todo dia às 22:00"
echo "==================================="