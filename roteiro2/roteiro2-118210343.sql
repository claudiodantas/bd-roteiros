-- --------QUESTÃO 1--------

CREATE TABLE tarefas (
	PK_id_tarefa integer,
	descricao text,
	func_resp_cpf varchar(11),
	prioridade integer,
	estado varchar(1)
);

INSERT INTO tarefas VALUES (2147483646, 
    'limpar chão do corredor central',
    '98765432111', 0, 'F'
);

INSERT INTO tarefas VALUES (2147483647,
    'limpar janelas da sala 203',
    '98765432122', 1, 'F'
);

INSERT INTO tarefas VALUES (null, null, null, null, null);


INSERT INTO tarefas VALUES (2147483644,
    'limpar chão do corredor superior',
    '987654323211', 0, 'F'
);

-- ERROR:  value too long for type character varying(11)

INSERT INTO tarefas VALUES (2147483643,
    'limpar chão do corredor superior',
    '98765432321', 0, 'FF'
);

-- ERROR:  value too long for type character varying(1)

-- --------QUESTÃO 2--------

INSERT INTO tarefas VALUES (2147483648,
    'limpar portas do térreo',
    '32323232955', 4, 'A'
);

-- ERROR:  integer out of range
-- Alterei o tipo da coluna 'pk_id_tarefa' pra bigint;

ALTER TABLE tarefas ALTER COLUMN pk_id_tarefa TYPE bigint;

-- -------QUESTÃO 3--------
-- Para mudar o tipo da penúltima coluna de integer para smallint,
-- precisei excluir a coluna e criar novamente, por causa da não
-- conversabilidade de integer para smallint, imagino.

ALTER TABLE tarefas DROP COLUMN prioridade;

ALTER TABLE tarefas ADD prioridade smallint;

-- Inserções foram executadas com sucesso

INSERT INTO tarefas (pk_id_tarefa, descricao, func_resp_cpf, 
    prioridade, estado) VALUES (2147483649,
    'limpar portas da entrada principal', 
    '32322525199', 32767, 'A'
);

INSERT INTO tarefas (pk_id_tarefa, descricao, func_resp_cpf, 
    prioridade, estado) VALUES (2147483649,
    'limpar portas da entrada principal', 
    '32322525199', 32767, 'A'
);

INSERT INTO tarefas (id, descricao, func_resp_cpf, 
    prioridade, status) VALUES (2147483660, 'limpar portas do 2o andar',
    '12345678911', 2, 'A'
);

-- -------QUESTÃO 4--------
-- Só precisei renomear o nome de duas colunas

ALTER TABLE tarefas RENAME COLUMN PK_id_tarefa TO id;

ALTER TABLE tarefas RENAME COLUMN estado TO status;

-- Antes de settar para NOT NULL todas as colunas, precisei
-- deletar as linhas com valores nulos, cadastrados anteriormente
-- para testes.
-- Precisei fazer o mesmo com a coluna prioridade porque
-- ela precisou ser excluída como explicado na questão 3

DELETE FROM tarefas WHERE id IS NULL;

DELETE FROM tarefas WHERE prioridade IS NULL;

-- Settando para NOT NULL

ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;

ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;

ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;

ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;

ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;


-- -------QUESTÃO 5--------

INSERT INTO tarefas (id, descricao, func_resp_cpf, 
    prioridade, status) VALUES (2147483653, 'limpar portas do 1o andar',
    '32323232911', 2, 'A'
);

INSERT INTO tarefas (id, descricao, func_resp_cpf, 
    prioridade, status) VALUES (2147483653, 'aparar a grama da área frontal',
    '32323232911', 2, 'A'
);

-- Imagino que a execução do segundo INSERT não deva ocorrer porque
-- ela possui um 'id' igual ao 'id' do primeiro INSERT. Logo, defini
-- o id como chave primária.

ALTER TABLE tarefas ADD PRIMARY KEY (id);

-- Quando tento realizar o segundo INSERT, o seguinte erro é mostrado:

-- ERROR:  duplicate key value violates unique constraint "tarefas_pkey"

-- -------QUESTÃO 6--------
-- 6.A)

ALTER TABLE tarefas ADD CONSTRAINT func_resp_cpf
    CHECK (LENGTH(func_resp_cpf) = 11);

INSERT INTO tarefas (id, descricao, func_resp_cpf, 
    prioridade, status) VALUES (100, 'aparar a grama da área frontal',
    '323232329', 2, 'A'
);

-- O seguinte erro aparece ao tentar fazer a inserção acima:
-- ERROR:  new row for relation "tarefas" violates check constraint "func_resp_cpf"

-- 6.B)

-- Alterando os valores antes de adicionar a restrição

UPDATE tarefas SET status = 'P' WHERE status = 'A';

UPDATE tarefas SET status = 'E' WHERE status = 'R';

UPDATE tarefas SET status = 'C' WHERE status = 'F';

-- Adicionando a restrição

ALTER TABLE tarefas ADD CONSTRAINT status CHECK(status IN ('P', 'E', 'C'));

-- O seguinte erro aparece quando tento burlar a restrição:
-- ERROR:  new row for relation "tarefas" violates check constraint "status"

-- -------QUESTÃO 7--------

-- Primeiro ajustando as prioridades cadastradas maiores que 5
UPDATE tarefas SET prioridade = 5 WHERE prioridade > 5;

ALTER TABLE tarefas ADD CONSTRAINT prioridade
    CHECK (prioridade < 5 and prioridade >= 0
);

-- -------QUESTÃO 8--------
CREATE TABLE funcionario (
    cpf VARCHAR(11) PRIMARY KEY,
    data_nasc DATE NOT NULL,
    nome VARCHAR(40) NOT NULL,
    funcao VARCHAR(11) NOT NULL,
    nivel CHAR(1),
    superior_cpf varchar(11),

    CHECK (LENGTH(cpf) = 11),
    CHECK ((funcao = 'LIMPEZA' AND superior_cpf IS NOT NULL) OR funcao ='SUP_LIMPEZA'),
    CHECK (nivel IN ('J', 'P', 'S'))
);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('12345678911', '1980-05-07', 'Pedro da Silva',
    'SUP_LIMPEZA', 'S', null
);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('12345678912', '1980-03-08', 'Jose da Silva',
    'LIMPEZA', 'J', '12345678911'
);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('12345678913', '1980-04-09', 'Joao da Silva',
    'LIMPEZA', 'J', null
);

-- O seguinte erro é apresentado quando tenta fazer a inserção acima:
-- ERROR:  new row for relation "funcionario" violates check constraint "suplimp"

-- -------QUESTÃO 9--------

-- Inserções executadas com sucesso
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('12345678913', '1981-05-07', 'Pedro da Silva',
    'SUP_LIMPEZA', 'S', null
);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('12345678914', '1982-05-07', 'Pedro da Silva',
    'LIMPEZA', 'S', '12345678913'
);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('12345678921', '1983-05-07', 'Rafael da Silva',
    'SUP_LIMPEZA', 'S', '12345678913'
);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('12345678922', '1984-05-07', 'Carlos da Silva',
    'SUP_LIMPEZA', 'P', null
);

-- Inserções não executadas

--Insert com cpf menor que 11
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('123456789', '1981-05-07', 'Pedro da Silva',
    'SUP_LIMPEZA', 'S', null
);
-- ERROR:  new row for relation "funcionario" violates check constraint "funcionario_cpf_check"

--Insert com cpf maior que 11
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('123456789111', '1981-05-07', 'Pedro da Silva',
    'SUP_LIMPEZA', 'S', null
);
--ERROR:  value too long for type character varying(11)

--nivel diferente de 'J`, `P` e `S`
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)
    VALUES ('12345678920', '1981-05-07', 'Pedro da Silva',
    'SUP_LIMPEZA', 'K', null
);
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_nivel_check"

-- -------QUESTÃO 10--------

-- Opção 1
ALTER TABLE funcionario ADD CONSTRAINT chave_estrangeira 
    FOREIGN KEY (superior_cpf) REFERENCES funcionario(cpf)
    ON DELETE CASCADE;

-- Precisei fazer a atualização do func_resp_cpf da tabela tarefas
-- para adicioná-la como chave estrangeira.
UPDATE tarefas SET func_resp_cpf = '12345678913' WHERE func_resp_cpf = '32323232911';

UPDATE tarefas SET func_resp_cpf = '12345678914' WHERE func_resp_cpf = '12345678911';

ALTER TABLE tarefas ADD CONSTRAINT chave_estrangeira
    FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf)
    ON DELETE CASCADE;

DELETE FROM funcionario WHERE cpf = '12345678913';

-- Foram deletadas 3 linhas de funcionario, graças ao efeito DELETE ON CASCADE
-- As linhas de tarefas, mesmo onde o func_resp_cpf era diferente do deletado,
-- também foram apagadas.

-- Opção 2
-- removi as constraints anteriores para adicionar a DELETE RESTRICT
ALTER TABLE funcionario DROP CONSTRAINT chave_estrangeira;

ALTER TABLE tarefas DROP CONSTRAINT chave_estrangeira;

ALTER TABLE funcionario ADD CONSTRAINT chave_estrangeira 
    FOREIGN KEY (superior_cpf) REFERENCES funcionario(cpf)
    ON DELETE RESTRICT;

ALTER TABLE tarefas ADD CONSTRAINT chave_estrangeira
    FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf)
    ON DELETE RESTRICT;

-- tentativa de remoção de funcionário com cpf chave estrangeira em tarefas
DELETE FROM funcionario WHERE cpf = '12345678922';

-- O seguinte erro é apresentado quando se tenta remover:
-- ERROR:  update or delete on table "funcionario" violates foreign key
-- constraint "chave_estrangeira" on table "tarefas"

-- -------QUESTÃO 11--------

ALTER TABLE tarefas ADD CONSTRAINT podesernull 
    CHECK ((func_resp_cpf = null and status = 'P') 
    OR func_resp_cpf IS NOT NULL);


