#!/bin/bash

echo "==================================="
echo "Configurando RabbitMQ"
echo "==================================="

# Cria o diretório para o RabbitMQ
sudo mkdir -p /home/ubuntu/rabbitmq
sudo chown ubuntu:ubuntu /home/ubuntu/rabbitmq

# Copia o Docker Compose do RabbitMQ
echo "Copiando arquivo compose-rabbit.yaml..."
cp /tmp/compose-rabbit.yaml /home/ubuntu/compose-rabbit.yaml
sudo chown ubuntu:ubuntu /home/ubuntu/compose-rabbit.yaml
echo "Arquivo compose-rabbit.yaml copiado com sucesso!"

# Verifica se o arquivo foi criado corretamente
if [ -f /home/ubuntu/compose-rabbit.yaml ]; then
    echo "Verificando conteúdo do compose-rabbit.yaml:"
    cat /home/ubuntu/compose-rabbit.yaml
else
    echo "ERRO: Arquivo compose-rabbit.yaml não foi criado!"
    exit 1
fi

echo "==================================="
echo "Iniciando RabbitMQ via Docker Compose"
echo "==================================="

# Inicia o RabbitMQ
echo "Iniciando RabbitMQ..."
cd /home/ubuntu && sudo docker compose -f compose-rabbit.yaml up -d

# Aguarda o RabbitMQ iniciar
echo "Aguardando RabbitMQ inicializar..."
sleep 15

# Verifica se o container está rodando
echo "Verificando containers RabbitMQ:"
sudo docker ps | grep rabbitmq

echo "==================================="
echo "RabbitMQ instalado e iniciado com sucesso!"
echo "Management UI: http://IP:15672"
echo "Usuário: myuser / Senha: secret"
echo "==================================="
