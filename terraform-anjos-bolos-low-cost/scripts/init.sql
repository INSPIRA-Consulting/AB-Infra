-- Criação da Database
CREATE DATABASE IF NOT EXISTS anjos_bolos;
USE anjos_bolos;

-- Tabela Usuario
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(25) NOT NULL,
    telefone VARCHAR(15) NOT NULL UNIQUE,
    funcao VARCHAR(50) NOT NULL
);

-- Tabela Ingrediente
CREATE TABLE Ingrediente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    custoMedida DECIMAL(12,10) NOT NULL
);

-- Tabela Categoria_Produto
CREATE TABLE Categoria_Produto (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    descricao VARCHAR(60) NOT NULL
);

-- Tabela Produto
CREATE TABLE Produto (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    precoFinal DECIMAL(5,2) NOT NULL,
    custoProducao DECIMAL(5,2) NOT NULL,
    fkCategoriaProduto INT,
    CONSTRAINT fk_categoria_produto FOREIGN KEY (fkCategoriaProduto) REFERENCES Categoria_Produto(id)
);

-- Tabela Tipo_Receita
CREATE TABLE Tipo_Receita (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    descricao VARCHAR(60) NOT NULL
);

-- Tabela Cliente
CREATE TABLE Cliente (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL UNIQUE
);

-- Tabela Receita
CREATE TABLE Receita (
	id INT,
    nome VARCHAR(60) NOT NULL,
    fkIngrediente INT NOT NULL,
    quantidade FLOAT NOT NULL,
    unidadeMedida VARCHAR(20) NOT NULL,
    fkTipoReceita INT NOT NULL,
    CONSTRAINT fk_receita_ingrediente FOREIGN KEY (fkIngrediente) REFERENCES Ingrediente(id),
    CONSTRAINT fk_tipo_receita FOREIGN KEY (fkTipoReceita) REFERENCES Tipo_Receita(id),
    CONSTRAINT pk_receita PRIMARY KEY(id, fkIngrediente)
);

-- Tabela Composicao_Produto
CREATE TABLE Composicao_Produto (
	fkProduto INT,
    fkReceita INT,
    fkIngrediente INT,
    quantidade FLOAT NOT NULL,
    observacao VARCHAR(255),
    CONSTRAINT fk_composicao_produto FOREIGN KEY (fkProduto) REFERENCES Produto(id),
    CONSTRAINT fk_composicao_receita FOREIGN KEY (fkReceita) REFERENCES Receita(id),
    CONSTRAINT fk_composicao_ingrediente FOREIGN KEY (fkIngrediente) REFERENCES Receita(fkIngrediente),
    CONSTRAINT pk_composicao_produto PRIMARY KEY(fkProduto, fkReceita, fkIngrediente)
);

-- Tabela Pedido
CREATE TABLE Pedido (
	id INT PRIMARY KEY AUTO_INCREMENT,
    dataPedido DATETIME NOT NULL,
    dataRetirada DATETIME,
    dataPagamento DATETIME,
    formaPagamento VARCHAR(255),
    status VARCHAR(255) NOT NULL,
    observacao VARCHAR(255),
    fkUsuarioResponsavel INT NOT NULL,
    fkCliente INT,
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (fkUsuarioResponsavel) REFERENCES Usuario(id),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (fkCliente) REFERENCES Cliente(id)
);

CREATE TABLE Item_Pedido (
	id INT PRIMARY KEY AUTO_INCREMENT,
    fkPedido INT NOT NULL,
    fkProduto INT NOT NULL,
    quantidade FLOAT NOT NULL,
    valorFinal DECIMAL(5,2) NOT NULL,
    custoProducao DECIMAL(5,2) NOT NULL,
    peso FLOAT,
    CONSTRAINT fk_item_pedido FOREIGN KEY (fkPedido) REFERENCES Pedido(id),
    CONSTRAINT fk_item_produto FOREIGN KEY (fkProduto) REFERENCES Produto(id)
);

SELECT * FROM Ingrediente;
SELECT * FROM Usuario;
SELECT * FROM Cliente;
SELECT * FROM Categoria_Produto;
SELECT * FROM Produto;
SELECT * FROM Tipo_Receita;
SELECT * FROM Receita;
SELECT * FROM Composicao_Produto;
SELECT * FROM Pedido;
SELECT * FROM Item_Pedido;