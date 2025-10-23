#!/bin/bash

# Script para instalar RabbitMQ no Ubuntu

set -e

echo "Atualizando repositórios..."
sudo apt update

echo "Instalando dependências..."
sudo apt install -y curl gnupg apt-transport-https

echo "Adicionando chave GPG do RabbitMQ..."
curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA | sudo gpg --dearmor -o /usr/share/keyrings/com.rabbitmq.team.gpg

echo "Adicionando repositório do RabbitMQ..."
echo "deb [signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-erlang/deb/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
echo "deb [signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-server/deb/ubuntu $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/rabbitmq.list

echo "Atualizando repositórios novamente..."
sudo apt update

echo "Instalando Erlang e RabbitMQ..."
sudo apt install -y erlang-base erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key erlang-runtime-tools erlang-snmp erlang-ssl erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl
sudo apt install -y rabbitmq-server

echo "Habilitando e iniciando o serviço RabbitMQ..."
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

echo "Habilitando plugin de management..."
sudo rabbitmq-plugins enable rabbitmq_management

echo "Criando usuário admin..."
sudo rabbitmqctl add_user admin admin123
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

echo "RabbitMQ instalado com sucesso!"
echo "Interface web disponível em: http://localhost:15672"
echo "Usuário: admin"
echo "Senha: admin123"