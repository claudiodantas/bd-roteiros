-- incompleto por motivos de preguiça, fazer o que

CREATE TABLE farmacias(
    pk_id INTEGER PRIMARY KEY,
    tipo varchar(1) NOT NULL,
    fk_gerente INTEGER NOT NULL,
    fk_endereco INTEGER NOT NULL

);

CREATE TABLE funcionarios(
    pk_id INTEGER PRIMARY KEY, 
    fk_farmacia INTEGER NULL, -- pode ser nulo [OK]
    tipo char NOT NULL

);

CREATE TABLE medicamentos(
    pk_id INTEGER PRIMARY KEY,
    receita BOOLEAN NOT NULL -- pode ser exclusiva com receita. Se for exclusiva com receita (TRUE), ele só poderá ser vendiudo à clientes cadastrados.
);

CREATE TABLE vendas (
    pk_id INTEGER PRIMARY KEY,
    fk_funcionario INTEGER NOT NULL, -- não é possível excluir funcionário associado à uma venda
    cliente INTEGER NOT NULL, -- Não colocarei como chave estrangeira pq esta pode ser feita para qualquer cliente, cadastrado ou não.
    fk_medicamento INTEGER NOT NULL -- não excluir medicamento vinculado à alguma venda
    
);

CREATE TABLE entregas(
    pk_id INTEGER PRIMARY KEY,
    fk_farmacia INTEGER NOT NULL,
    fk_cliente INTEGER NOT NULL, -- cliente precisa estar cadastrado (ou seja, existir no bd) [OK]
    fk_endereco INTEGER NOT NULL -- porque pode existir mais de um endereço associado ao cliente

);

CREATE TABLE clientes( -- faz sentido o cliente armazenar endereço? acho que não
    pk_id INTEGER PRIMARY KEY,
    data_nasc TIMESTAMP NOT NULL 

);

-- ----------EXTRAS------------
CREATE TABLE enderecos_clientes( 
    pk_id INTEGER PRIMARY KEY,
    tipo char(1),
    estado char,
    cidade char,
    bairro char,
    rua char,
    complemento char

    CHECK (tipo IN ('r', 't', 'o')) -- "residência", "trabalho" ou "outro", respectivamente
);

CREATE TABLE enderecos_farmacias(
    pk_id INTEGER PRIMARY KEY,
    estado char,
    cidade char,
    bairro char UNIQUE
);



-- ----------CONSTRAINTS----------------

-- -----Foreign keys
-- Farmácias
--[OK]
ALTER TABLE farmacias ADD CONSTRAINT fk_gerente
    FOREIGN KEY (fk_gerente) REFERENCES funcionarios (pk_id); -- funcionario precisa ser adminsitrador ou farmaceutico
--[OK]
ALTER TABLE farmacias ADD CONSTRAINT fk_endereco 
    FOREIGN KEY (fk_endereco) REFERENCES enderecos_farmacias (pk_id);


-- Funcionarios
--[OK]
ALTER TABLE funcionarios ADD CONSTRAINT fk_farmacia 
    FOREIGN KEY (fk_farmacia) REFERENCES farmacias (pk_id);


-- Medicamentos

-- Vendas
--[OK]
ALTER TABLE vendas ADD CONSTRAINT fk_funcionario 
    FOREIGN KEY (fk_funcionario) REFERENCES funcionarios (pk_id);

-- Entregas
--[OK]
ALTER TABLE entregas ADD CONSTRAINT fk_cliente
    FOREIGN KEY (fk_cliente) REFERENCES clientes (pk_id);


-- -----Checks
-- Farmácias

ALTER TABLE farmacias ADD CONSTRAINT
    tipo CHECK (tipo IN ('s', 'f')); -- "sede" e "filial" respectivamente

-- Funcionários
ALTER TABLE funcionarios ADD CONSTRAINT
    tipo CHECK (tipo IN ('far', 'ven', 'ent', 'cai', 'adm')); -- "farmaceutico", "vendedor", "entregador", "caixa", "administrador", respectivamente


-- Clientes
ALTER TABLE clientes ADD CONSTRAINT 
    age CHECK (age(data_nasc) >= age('2002-03-26','2020-03-26'));
