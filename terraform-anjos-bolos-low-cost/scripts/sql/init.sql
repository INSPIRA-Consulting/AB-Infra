-- Criação da Database
-- drop database anjos_bolos;
CREATE DATABASE IF NOT EXISTS anjos_bolos;
USE anjos_bolos;

-- Criação das tabelas (exemplo básico)
CREATE TABLE IF NOT EXISTS produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- Inserção de dados básicos
INSERT INTO produtos (nome, preco, descricao, categoria) VALUES
('Bolo de Chocolate', 35.90, 'Delicioso bolo de chocolate com cobertura', 'Bolos'),
('Bolo de Cenoura', 28.50, 'Bolo de cenoura tradicional com cobertura de chocolate', 'Bolos'),
('Bolo Red Velvet', 42.00, 'Bolo red velvet com cream cheese', 'Bolos Premium'),
('Bolo de Limão', 30.00, 'Bolo de limão com cobertura azedinha', 'Bolos'),
('Bolo de Coco', 32.90, 'Bolo de coco com coco ralado', 'Bolos');