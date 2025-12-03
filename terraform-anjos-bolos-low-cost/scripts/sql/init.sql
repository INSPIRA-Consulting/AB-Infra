-- Criação do usuário de serviço
CREATE USER IF NOT EXISTS'anjos_bolos_api'@'%' IDENTIFIED BY '@nj0sB0l0s';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, 
       SHOW VIEW, EVENT, TRIGGER, LOCK TABLES
ON anjos_bolos.*
TO 'anjos_bolos_api'@'%';

GRANT PROCESS ON *.* 
TO 'anjos_bolos_api'@'%';


-- Aplicar as mudanças
FLUSH PRIVILEGES;

-- Criação da Database
DROP DATABASE IF EXISTS anjos_bolos;
CREATE DATABASE IF NOT EXISTS anjos_bolos;
USE anjos_bolos;

-- =======================
-- Tabela Usuario
-- =======================
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(60) NOT NULL,
    telefone VARCHAR(15) NOT NULL UNIQUE,
    funcao VARCHAR(50) NOT NULL,
    CONSTRAINT chk_funcao CHECK (funcao IN ('ADMINISTRADOR', 'GERENTE', 'ATENDENTE'))
);

-- =======================
-- Tabela Ingrediente
-- =======================
CREATE TABLE Ingrediente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    custoMedida DECIMAL(12,10) NOT NULL
);

-- =======================
-- Tabela Categoria_Produto
-- =======================
CREATE TABLE Categoria_Produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    descricao VARCHAR(60) NOT NULL
);

-- =======================
-- Tabela Produto
-- =======================
CREATE TABLE Produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    precoFinal DECIMAL(5,2) NOT NULL,
    custoProducao DECIMAL(5,2) NOT NULL,
    fkCategoriaProduto INT,
    CONSTRAINT fk_categoria_produto FOREIGN KEY (fkCategoriaProduto) REFERENCES Categoria_Produto(id)
);

-- =======================
-- Tabela Tipo_Receita
-- =======================
CREATE TABLE Tipo_Receita (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    descricao VARCHAR(60) NOT NULL
);

-- =======================
-- Tabela Cliente
-- =======================
CREATE TABLE Cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL UNIQUE
);

-- =======================
-- Tabela Receita
-- =======================
CREATE TABLE Receita (
    id INT,
    nome VARCHAR(60) NOT NULL,
    fkIngrediente INT NOT NULL,
    quantidade FLOAT NOT NULL,
    unidadeMedida VARCHAR(20) NOT NULL,
    fkTipoReceita INT NOT NULL,
    CONSTRAINT fk_receita_ingrediente FOREIGN KEY (fkIngrediente) REFERENCES Ingrediente(id),
    CONSTRAINT fk_tipo_receita FOREIGN KEY (fkTipoReceita) REFERENCES Tipo_Receita(id),
    CONSTRAINT pk_receita PRIMARY KEY(id, fkIngrediente),
    CONSTRAINT chk_unidadeMedida CHECK (unidadeMedida IN (
        'UNIDADE', 'GRAMA', 'QUILOGRAMA', 'LITRO', 'MILILITRO', 
        'XICARA_CHA', 'COLHER_SOPA', 'COLHER_CHA', 'COLHER_CAFE', 
        'COLHER_SOBREMESA', 'PITADA', 'COPO_AMERICANO'
    ))
);

-- =======================
-- Tabela Composicao_Produto
-- =======================
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

-- =======================
-- Tabela Pedido
-- =======================
CREATE TABLE Pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dataPedido DATETIME NOT NULL,
    dataRetirada DATETIME,
    dataPagamento DATETIME,
    formaPagamento VARCHAR(50),
    status VARCHAR(50) NOT NULL,
    observacao VARCHAR(255),
    fkUsuarioResponsavel INT NOT NULL,
    fkCliente INT,
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (fkUsuarioResponsavel) REFERENCES Usuario(id),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (fkCliente) REFERENCES Cliente(id),
    CONSTRAINT chk_formaPagamento CHECK (formaPagamento IN (
        'DINHEIRO', 'CARTAO_CREDITO', 'CARTAO_DEBITO', 'VOUCHER', 'PIX'
    )),
    CONSTRAINT chk_statusPedido CHECK (status IN (
        'CONFIRMADO', 'PENDENTE_PAGAMENTO', 'CANCELADO', 'FINALIZADO'
    ))
);

-- =======================
-- Tabela Item_Pedido
-- =======================
CREATE TABLE Item_Pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fkPedido INT NOT NULL,
    fkProduto INT NOT NULL,
    quantidade FLOAT NOT NULL,
    precoUnitario DECIMAL(5,2) NOT NULL,
    custoProducao DECIMAL(5,2) NOT NULL,
    peso FLOAT,
    CONSTRAINT fk_item_pedido FOREIGN KEY (fkPedido) REFERENCES Pedido(id),
    CONSTRAINT fk_item_produto FOREIGN KEY (fkProduto) REFERENCES Produto(id)
);

-- =======================
-- Tabela Detalhamento_Pedido
-- =======================
CREATE TABLE Detalhamento_Pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fkItemPedido INT NOT NULL,
    fkReceita INT NOT NULL,
    fkIngrediente INT NOT NULL,
    observacao VARCHAR(255),
    CONSTRAINT fk_detalhamento_item_pedido FOREIGN KEY (fkItemPedido) REFERENCES Item_Pedido(id),
    CONSTRAINT fk_detalhamento_receita FOREIGN KEY (fkReceita) REFERENCES Receita(id),
    CONSTRAINT fk_detalhamento_ingrediente FOREIGN KEY (fkIngrediente) REFERENCES Receita(fkIngrediente)
);
SELECT * FROM Usuario;

-- =======================
-- Usuários
-- =======================
INSERT INTO Usuario (nome, cpf, email, senha, telefone, funcao) VALUES
('root', '999.999.999-99', 'inspira@gmail.com', '$2a$10$P42PeHwYl2WTPhqC.8PMt.xdO8p18rG5VuEp2OiPzKOqFO0KYFjKu', '(11)99999-9999', 'ADMINISTRADOR'),
('Ana Souza', '123.456.789-00', 'ana@anjosbolos.com', '$2a$10$Z8.B8i/nCUICjbwwMl35gu72uaXfrlWle5nCASux4E4/TOVUQ57fS', '(11)90000-0001', 'ATENDENTE'),
('Carla Mendes', '123.123.123-12', 'carla@anjosbolos.com', '$2a$10$Z8.B8i/nCUICjbwwMl35gu72uaXfrlWle5nCASux4E4/TOVUQ57fS', '(11)90000-0003', 'GERENTE');