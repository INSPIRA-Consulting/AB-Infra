#!/bin/bash
# Script de instalação do MySQL Server no Ubuntu

set -e  # Para o script se houver erro

echo "==================================="
echo "Instalando MySQL Server"
echo "==================================="

# Atualiza o índice de pacotes
sudo apt-get update

# Define a senha root do MySQL sem prompt interativo
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root123'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root123'

# Instala o MySQL Server
sudo apt-get install -y mysql-server

# Inicia o serviço MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

echo "==================================="
echo "Configurando MySQL para aceitar conexões remotas"
echo "==================================="

# Configura o MySQL para aceitar conexões de qualquer IP
sudo sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Reinicia o MySQL para aplicar as mudanças
sudo systemctl restart mysql

echo "==================================="
echo "Executando scripts SQL"
echo "==================================="

# Espera o MySQL estar pronto
sleep 5

# Scripts SQL já copiados via provisioner para /tmp
echo "Scripts SQL disponíveis em /tmp/init.sql e /tmp/create_user.sql"

# Executa o script init.sql
if [ -f /tmp/init.sql ]; then
    echo "Executando init.sql..."
    sudo mysql -u root -proot123 < /tmp/init.sql
    echo "init.sql executado com sucesso!"
else
    echo "ERRO: Arquivo init.sql não encontrado!"
    exit 1
fi

# Executa o script create_user.sql
if [ -f /tmp/create_user.sql ]; then
    echo "Executando create_user.sql..."
    sudo mysql -u root -proot123 < /tmp/create_user.sql
    echo "create_user.sql executado com sucesso!"
else
    echo "ERRO: Arquivo create_user.sql não encontrado!"
    exit 1
fi

# Remove os arquivos temporários
rm -f /tmp/create_user.sql /tmp/init.sql

echo "==================================="
echo "MySQL instalado e configurado com sucesso!"
echo "==================================="

# Exibe o status do MySQL
sudo systemctl status mysql --no-pager

echo "==================================="
echo "Iniciando API via Docker Compose"
echo "==================================="

# Aguarda um pouco para garantir que MySQL está estável
sleep 5

# Verifica se o arquivo compose.yaml existe
if [ -f /home/ubuntu/compose.yaml ]; then
    echo "Arquivo compose.yaml encontrado, iniciando API..."
    cd /home/ubuntu && sudo docker compose -f compose.yaml up -d
    echo "API iniciada com sucesso!"
    
    # Verifica os containers rodando
    echo "Containers Docker ativos:"
    sudo docker ps
else
    echo "AVISO: Arquivo compose.yaml não encontrado!"
    echo "A API não foi iniciada."
fi

echo "==================================="
teecho "Iniciando RabbitMQ via Docker Compose"
echo "==================================="

# Verifica se o arquivo compose-rabbit.yaml existe
if [ -f /home/ubuntu/compose-rabbit.yaml ]; then
    echo "Arquivo compose-rabbit.yaml encontrado, iniciando RabbitMQ..."
    cd /home/ubuntu && sudo docker compose -f compose-rabbit.yaml up -d
    echo "RabbitMQ iniciado com sucesso!"
    
    # Verifica os containers rodando
    echo "Containers Docker ativos:"
    sudo docker ps
else
    echo "AVISO: Arquivo compose-rabbit.yaml não encontrado!"
    echo "RabbitMQ não foi iniciado."
fi

echo "==================================="
echo "Configuração completa finalizada!"
echo "==================================="
