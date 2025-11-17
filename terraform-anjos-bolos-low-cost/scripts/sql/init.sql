-- Criação da Database
-- drop database anjos_bolos;
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
    valorFinal DECIMAL(5,2) NOT NULL,
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


-- SELECTS das Tabelas
-- SELECT * FROM Ingrediente;
-- SELECT * FROM Usuario;
-- SELECT * FROM Cliente;
-- SELECT * FROM Categoria_Produto;
-- SELECT * FROM Produto;
-- SELECT * FROM Tipo_Receita;
-- SELECT * FROM Receita;
-- SELECT * FROM Composicao_Produto;
-- SELECT * FROM Pedido;
-- SELECT * FROM Item_Pedido;


-- =======================
-- Usuários
-- =======================
INSERT INTO Usuario (nome, cpf, email, senha, telefone, funcao) VALUES
('root', '999.999.999-99', 'inspira@gmail.com', '$2a$10$P42PeHwYl2WTPhqC.8PMt.xdO8p18rG5VuEp2OiPzKOqFO0KYFjKu', '(11)99999-9999', 'ADMINISTRADOR'),
('Ana Souza', '123.456.789-00', 'ana@anjosbolos.com', 'senha123', '(11)90000-0001', 'ATENDENTE'),
('Carla Mendes', '123.123.123-12', 'carla@anjosbolos.com', 'senha123', '(11)90000-0003', 'GERENTE');

-- =======================
-- Ingredientes
-- =======================
INSERT INTO Ingrediente (nome, custoMedida) VALUES
('Farinha de Trigo', 0.0050),
('Açúcar Refinado', 0.0040),
('Ovos', 0.2500),
('Leite', 0.0100),
('Manteiga', 0.0800),
('Chocolate em Pó', 0.0500),
('Fermento', 0.0300),
('Coco Ralado', 0.0450),
('Suco de Laranja', 0.0200),
('Fubá', 0.0060),
('Nozes', 0.1500),
('Morango', 0.0700),
('Refrigerante', 0.0150),
('Café', 0.0250),
('Presunto', 0.0500),
('Queijo', 0.0550),
('Frango Desfiado', 0.0600),
('Molho de Tomate', 0.0300);

-- =======================
-- Categorias de Produto
-- =======================
INSERT INTO Categoria_Produto (nome, descricao) VALUES
('Bolo Tradicional', 'Bolos simples e caseiros'),
('Bebida', 'Bebidas diversas da casa'),
('Salgados', 'Salgados assados e fritos'),
('Bolo de Pote', 'Bolos individuais servidos no pote'),
('Bolo de Festa', 'Bolos decorados e personalizados');

-- =======================
-- Produtos
-- =======================
INSERT INTO Produto (nome, precoFinal, custoProducao, fkCategoriaProduto) VALUES
-- Bolos Tradicionais
('Bolo de Chocolate', 50.00, 30.00, 1),
('Bolo de Cenoura', 40.00, 25.00, 1),
('Bolo de Fubá', 35.00, 20.00, 1),
('Bolo de Laranja', 38.00, 22.00, 1),
('Bolo de Coco', 45.00, 27.00, 1),
('Bolo de Limão', 42.00, 25.00, 1),
('Bolo Red Velvet', 70.00, 40.00, 1),
('Bolo Prestígio', 60.00, 35.00, 1),
('Bolo Ninho com Morango', 65.00, 38.00, 1),

-- Bolos de Pote
('Bolo de Pote de Chocolate', 10.00, 5.50, 4),
('Bolo de Pote de Morango', 11.00, 6.00, 4),
('Bolo de Pote de Coco', 10.50, 5.80, 4),
('Bolo de Pote Ninho', 13.50, 7.80, 4),
('Bolo de Pote Prestígio', 12.00, 6.50, 4),

-- Salgados
('Coxinha de Frango', 6.00, 3.00, 3),
('Empada de Palmito', 7.00, 3.50, 3),
('Esfiha de Carne', 6.50, 3.20, 3),
('Coxinha Catupiry', 7.00, 3.50, 3),
('Quiche Lorraine', 9.50, 5.00, 3),
('Pão de Queijo', 4.50, 1.80, 3),

-- Bebidas
('Café Expresso', 5.00, 1.50, 2),
('Cappuccino', 8.00, 3.50, 2),
('Refrigerante Lata', 6.00, 2.00, 2),
('Suco Natural Laranja', 8.00, 2.50, 2),
('Suco Natural Maracujá', 8.00, 2.80, 2),
('Chocolate Quente', 10.00, 4.00, 2);

-- =======================
-- Tipos de Receita
-- =======================
INSERT INTO Tipo_Receita (nome, descricao) VALUES
('Massa de Bolo', 'Base de massas para bolos'),
('Recheio', 'Recheios de bolos e doces'),
('Cobertura', 'Coberturas e glacês'),
('Salgado', 'Receitas de salgados');

-- =======================
-- Clientes
-- =======================
INSERT INTO Cliente (nome, cpf, telefone) VALUES
('Fernanda Costa', '555.666.777-88', '(11)98888-0001'),
('Marcos Oliveira', '222.333.444-55', '(11)98888-0002'),
('Juliana Ribeiro', '222.111.444-00', '(11)97777-0001'),
('Paulo Nascimento', '333.222.555-11', '(11)97777-0002'),
('Gabriel Moraes', '444.333.666-22', '(11)97777-0003'),
('Larissa Martins', '555.444.777-33', '(11)97777-0004'),
('Claudio Silva', '666.555.888-44', '(11)97777-0005'),
('Beatriz Alves', '777.666.999-55', '(11)97777-0006'),
('Thiago Santos', '888.777.111-66', '(11)97777-0007'),
('Rafaela Kruger', '999.888.000-77', '(11)97777-0008'),
('João Lucas', '111.999.222-88', '(11)97777-0009'),
('Mariana Dias', '444.888.111-99', '(11)97777-0010');

-- =======================
-- Receitas
-- =======================
INSERT INTO Receita (id, nome, fkIngrediente, quantidade, unidadeMedida, fkTipoReceita) VALUES
(1, 'Massa Chocolate', 1, 500, 'GRAMA', 1),
(1, 'Massa Chocolate', 2, 300, 'GRAMA', 1),
(1, 'Massa Chocolate', 3, 4, 'UNIDADE', 1),
(1, 'Massa Chocolate', 4, 200, 'MILILITRO', 1),
(1, 'Massa Chocolate', 7, 10, 'GRAMA', 1),

(2, 'Massa Cenoura', 1, 400, 'GRAMA', 1),
(2, 'Massa Cenoura', 2, 200, 'GRAMA', 1),
(2, 'Massa Cenoura', 3, 3, 'UNIDADE', 1),
(2, 'Massa Cenoura', 4, 150, 'MILILITRO', 1),
(2, 'Massa Cenoura', 7, 10, 'GRAMA', 1),

(3, 'Recheio Chocolate', 6, 100, 'GRAMA', 2),
(3, 'Recheio Chocolate', 5, 50, 'GRAMA', 2),

(4, 'Massa Red Velvet', 1, 450, 'GRAMA', 1),
(4, 'Massa Red Velvet', 2, 300, 'GRAMA', 1),
(4, 'Massa Red Velvet', 3, 3, 'UNIDADE', 1),
(4, 'Massa Red Velvet', 4, 200, 'MILILITRO', 1),
(4, 'Massa Red Velvet', 7, 12, 'GRAMA', 1),
(4, 'Massa Red Velvet', 14, 30, 'GRAMA', 1),

(5, 'Recheio Ninho', 5, 100, 'GRAMA', 2),
(5, 'Recheio Ninho', 4, 150, 'MILILITRO', 2),
(5, 'Recheio Ninho', 2, 80, 'GRAMA', 2),
(5, 'Recheio Ninho', 3, 2, 'UNIDADE', 2),

(6, 'Massa Prestígio', 1, 480, 'GRAMA', 1),
(6, 'Massa Prestígio', 2, 300, 'GRAMA', 1),
(6, 'Massa Prestígio', 3, 4, 'UNIDADE', 1),
(6, 'Massa Prestígio', 4, 220, 'MILILITRO', 1),
(6, 'Massa Prestígio', 8, 100, 'GRAMA', 1);

-- =======================
-- Composição dos Produtos
-- =======================
INSERT INTO Composicao_Produto (fkProduto, fkReceita, fkIngrediente, quantidade, observacao) VALUES
(1, 1, 1, 500, 'Base da massa de chocolate'),
(1, 3, 6, 100, 'Recheio de chocolate'),
(2, 2, 1, 400, 'Base da massa de cenoura'),
(3, 1, 1, 500, 'Massa base para bolo de festa'),
(3, 3, 6, 100, 'Recheio de chocolate para festa'),
(16, 4, 1, 450, 'Massa Red Velvet base'),
(16, 5, 5, 100, 'Recheio leite ninho'),
(17, 6, 1, 480, 'Massa Prestígio base'),
(17, 3, 6, 120, 'Recheio chocolate extra'),
(18, 5, 5, 150, 'Recheio ninho com morango');

-- =======================
-- Pedidos
-- =======================
INSERT INTO Pedido (dataPedido, dataRetirada, dataPagamento, formaPagamento, status, observacao, fkUsuarioResponsavel, fkCliente) VALUES
('2025-10-20 10:00:00', '2025-10-22 18:00:00', '2025-10-20 10:30:00', 'CARTAO_CREDITO', 'FINALIZADO', 'Bolo para aniversário', 2, 1),
('2025-10-25 09:00:00', NULL, NULL, 'PIX', 'FINALIZADO', 'Pedido especial de festa', 1, 2),
('2025-11-01 09:30:00', '2025-11-03 16:00:00', '2025-11-01 10:00:00', 'PIX', 'FINALIZADO', 'Bolo aniversário infantil', 1, 3),
('2025-11-02 14:15:00', NULL, NULL, 'DINHEIRO', 'PENDENTE_PAGAMENTO', 'Pedido aguardando pagamento', 2, 5),
('2025-11-03 08:00:00', '2025-11-03 12:30:00', '2025-11-03 08:10:00', 'CARTAO_DEBITO', 'FINALIZADO', NULL, 1, 8);

-- =======================
-- Itens do Pedido
-- =======================
INSERT INTO Item_Pedido (fkPedido, fkProduto, quantidade, valorFinal, custoProducao, peso) VALUES
(1, 1, 1, 50.00, 30.00, 1.2),
(1, 14, 5, 10.00, 5.00, 1.5),
(2, 7, 1, 120.00, 70.00, 3.0),
(3, 16, 1, 70.00, 40.00, 1.2),
(4, 10, 10, 7.00, 3.50, 1.5),
(5, 18, 2, 65.00, 39.00, 2.4);
