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

# Copia o Docker Compose da API
echo "Copiando arquivo compose.yaml..."
cp /tmp/compose-api.yaml /home/ubuntu/compose.yaml
sudo chown ubuntu:ubuntu /home/ubuntu/compose.yaml
echo "Arquivo compose.yaml copiado com sucesso!"

# Verifica se o arquivo foi criado corretamente
if [ -f /home/ubuntu/compose.yaml ]; then
    echo "Verificando conteúdo do compose.yaml:"
    cat /home/ubuntu/compose.yaml
else
    echo "ERRO: Arquivo compose.yaml não foi copiado!"
    exit 1
fi

echo "==================================="
echo "Ambiente da API preparado!"
echo "API será iniciada após MySQL estar pronto"
echo "==================================="
