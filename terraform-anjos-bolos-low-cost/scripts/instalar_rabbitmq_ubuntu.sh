#!/bin/bash

# Script para preparar ambiente para RabbitMQ via Docker

set -e

echo "Atualizando repositórios..."
sudo apt update

echo "Instalando dependências básicas..."
sudo apt install -y curl gnupg apt-transport-https

echo "RabbitMQ será executado via Docker Compose"
echo "Nenhuma instalação nativa necessária"