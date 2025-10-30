#!/bin/bash

echo "==================================="
echo "Configurando ambiente para API"
echo "==================================="

# Criando os diretórios necessários
sudo mkdir -p /home/ubuntu/backend
sudo mkdir -p /usr/share/api
sudo chown ubuntu:ubuntu /usr/share/api
sudo chown ubuntu:ubuntu /home/ubuntu/backend
echo "Diretórios criados com sucesso."

# Decodifica e salva o Docker Compose da API
echo "Criando arquivo compose.yaml..."
echo "${arquivo_docker_compose}" | base64 -d > /home/ubuntu/compose.yaml
sudo chown ubuntu:ubuntu /home/ubuntu/compose.yaml
echo "Arquivo compose.yaml criado com sucesso!"

# Verifica se o arquivo foi criado corretamente
if [ -f /home/ubuntu/compose.yaml ]; then
    echo "Verificando conteúdo do compose.yaml:"
    cat /home/ubuntu/compose.yaml
else
    echo "ERRO: Arquivo compose.yaml não foi criado!"
    exit 1
fi

echo "==================================="
echo "Ambiente da API preparado!"
echo "API será iniciada após MySQL estar pronto"
echo "==================================="
