-- Criação do usuário de serviço
CREATE USER 'anjos_bolos_api'@'%' IDENTIFIED BY '@nj0sB0l0s';

-- Conceder privilégios específicos para o banco anjos_bolos
GRANT SELECT, INSERT, UPDATE, DELETE ON anjos_bolos.* TO 'anjos_bolos_api'@'%';

-- Aplicar as mudanças
FLUSH PRIVILEGES;