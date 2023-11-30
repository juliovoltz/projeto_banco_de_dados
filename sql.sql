-- PostgreSQL 16
-- Definições:
-- - registros financeiros
-- - usuario cadastra dispesas diárias
-- - pode solicitar relatorio de gastos no mes atual
-- - pode cadastrar um limite de gasto pra determinado tipo no mes atual
-- -- não será bloqueado de cadastrar novos gastos, mas recebera um alerta de limite ultrapassado
-- - poderá informar um valor na sua conta, que será descontado de cada gasto cadastrado
-- - dispesas não poderão ter valores negativos ou zero
-- - dispesas serão do tipo 'Alimentação', 'Moradia', 'Transporte', 'Lazer', 'Outros'

create extension "uuid-ossp";

-- exclusão de tabelas

DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Conta CASCADE;
DROP TABLE IF EXISTS Saldo_adicionado CASCADE;
DROP TABLE IF EXISTS Tipo_despesa CASCADE;
DROP TABLE IF EXISTS Despesa CASCADE;
DROP TABLE IF EXISTS Registro_despesa CASCADE;


-- criação de tabelas

CREATE TABLE Usuario (
	cpf CHAR (11),
	nome varchar (20),
	sobrenome varchar (10),
	email varchar (30),
	telefone char (9),
	PRIMARY KEY (cpf)
);

CREATE TABLE Conta (
	id uuid default uuid_generate_v4(),
	saldo DECIMAL,
	cpf_usuario CHAR (11),
	PRIMARY KEY (id),
	FOREIGN KEY (cpf_usuario) references Usuario(cpf)
);

CREATE TABLE Saldo_adicionado (
	id uuid default uuid_generate_v4(),
	valor_adicionado DECIMAL,
	timestamp DATE,
	id_conta uuid,
	PRIMARY KEY (id),
	FOREIGN KEY (id_conta) references Conta(id)
);

CREATE TABLE Tipo_despesa (
	id uuid default uuid_generate_v4(),
	categoria varchar (11),
	PRIMARY KEY (id),
	CHECK (categoria IN ('Alimentacao', 'Moradia', 'Transporte', 'Lazer', 'Outros'))
);

CREATE TABLE Despesa (
	id uuid default uuid_generate_v4(),
	valor DECIMAL,
	id_tipo uuid,
	cpf_usuario char (11),
	PRIMARY KEY (id),
	FOREIGN KEY (cpf_usuario) references Usuario(cpf),
	FOREIGN KEY (id_tipo) references Tipo_despesa(id),
	CHECK (valor > 0)
);

CREATE TABLE Registro_despesa (
	id uuid default uuid_generate_v4(),
	timestamp DATE,
	id_despesa uuid,
	PRIMARY KEY (id),
	FOREIGN KEY (id_despesa) references Despesa(id)
);

CREATE TABLE Limite (
	id uuid default uuid_generate_v4(),
	valor_max DECIMAL,
	id_tipo uuid,
	cpf_usuario char (11),
	PRIMARY KEY (id),
	FOREIGN KEY (id_tipo) references Tipo_despesa(id),
	FOREIGN KEY (cpf_usuario) references Usuario(cpf)
);



-- criação de views
DROP VIEW IF EXISTS View_Soma_Despesas;

CREATE VIEW View_Soma_Despesas AS
SELECT
    td.id AS id_tipo,
    td.categoria,
    u.cpf AS cpf_usuario,
    SUM(d.valor) AS soma_despesas
FROM
    Tipo_despesa td
JOIN
    Despesa d ON td.id = d.id_tipo
JOIN
    Registro_despesa rd ON d.id = rd.id_despesa
JOIN
    Usuario u ON d.cpf_usuario = u.cpf
GROUP BY
    td.id, td.categoria, u.cpf;


SELECT * FROM View_Soma_Despesas v where v.cpf_usuario = '11111111111';

-- criação de triggers
DROP TRIGGER IF EXISTS MonitoraDespesas ON Despesa;

CREATE OR REPLACE FUNCTION processa_despesa()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
		INSERT INTO Registro_despesa (timestamp, id_despesa)
		VALUES (CURRENT_DATE, new.id);
	return new;
	end;
$$

CREATE TRIGGER MonitoraDespesas 
AFTER INSERT ON Despesa
FOR EACH ROW 
EXECUTE FUNCTION processa_despesa();



-- inserção iniciais

INSERT INTO Usuario (cpf, nome, sobrenome, email, telefone)
VALUES 
	('11111111111', 'Jao Pedro', 'Rocha', 'joaopedrorocha@gmail.com','123456789'),
	('22222222222', 'Maria Clara', 'Santos', 'mariaclarasantos@gmail.com','987654321');

INSERT INTO Conta (saldo, cpf_usuario)
VALUES 
	(2000, '11111111111'),
	(200, '22222222222');

SELECT * FROM Conta;

INSERT INTO Saldo_adicionado (valor_adicionado, timestamp, id_conta)
VALUES (195.5, TO_TIMESTAMP('2023-11-27 19:20:04', 'YYYY-MM-DD HH24:MI:SS'), 'f39e8211-0a60-40c2-8c5c-152b2f94039a');

INSERT INTO Tipo_despesa (categoria)
VALUES 
	('Alimentacao'),
	('Moradia'),
	('Transporte'),
	('Lazer'),
	('Outros');

SELECT * FROM Tipo_despesa;
/*
"4a1eb0bd-0b87-48f9-8fb0-7493bc976614"	"Alimentacao"
"f35adbc1-fa40-4b2c-a91a-7add2e088f52"	"Moradia"
"9fb706fe-a3cb-49df-aa8a-fe84963fc0a6"	"Transporte"
"3ddad60f-f555-4374-b2b2-c36db3984555"	"Lazer"
"96415043-5556-4dce-b246-3b7275678241"	"Outros"
*/


INSERT INTO Limite (valor_max, id_tipo, cpf_usuario)
VALUES (500, '4a1eb0bd-0b87-48f9-8fb0-7493bc976614', '11111111111');


-- segundas inserções

INSERT INTO Despesa (valor, id_tipo, cpf_usuario)
VALUES 
	(55.90, '9fb706fe-a3cb-49df-aa8a-fe84963fc0a6', '11111111111');

SELECT * FROM Despesa
SELECT * FROM Registro_despesa


