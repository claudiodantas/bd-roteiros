-- Comentários:
-- Questão 1:
-- OS erros que apareceram foram referentes ao integer
-- que estava sendo cadastrado ser grande demais.

-- Questão 2:
-- Alterei o tipo da coluna 'pk_id_tarefa' pra bigint;

-- Questão 3:
-- Para mudar o tipo da penúltima coluna de integer para smallint,
-- precisei excluir a coluna e criar novamente, por causa da não
-- conversabilidade de integer para smallint, imagino.

-- Questão 4:
-- Antes de settar para NOT NULL todas as colunas, precisei
-- deletar as linhas com valores nulos, cadastrados anteriormente
-- para testes.
-- Precisei fazer o mesmo com a coluna prioridade porque
-- ela precisou ser excluída como explicado na questão 3

-- Questão 5:
-- Imagino que a execução do segundo INSERT não deva ocorrer porque
-- ele possui um 'id' igual ao 'id' do primeiro INSERT. Logo, defini
-- o id como chave primária.

-- Questão 6:
-- Alterei os valores antes de adicionar as restrições.
-- O seguinte erro aparece quando tento burlar a restrição:
-- ERROR:  new row for relation "tarefas" violates check constraint "status"

-- Questão 7:
-- Primeiro alterei as prioridades que estavam maiores que 5
-- para aí sim adicionar a constraint.

-- Questão 8:
-- O seguinte erro é apresentado quando tenta fazer a inserção que viola a constraint:
-- ERROR:  new row for relation "funcionario" violates check constraint "suplimp"

-- Questão 9:
-- Os testes das constraints aconteceram com sucesso.

-- Questão 10:
-- Precisei fazer a atualização do func_resp_cpf da tabela tarefas
-- para adicioná-la como chave estrangeira.
-- Foram deletadas 3 linhas de funcionario, graças ao efeito DELETE ON CASCADE
-- As linhas de tarefas, mesmo onde o func_resp_cpf era diferente do deletado,
-- também foram apagadas, não entendi muito bem o porquê.
-- Para testar o ON DELETE RESTRICT precisei excluir as constraints anteiores.

-- Questão 11:
-- Me incomodou ter que ficar mudando as duas constraints das duas tabelas,
-- mas acredito que faça parte dos ossos do ofício.


-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 9.5.19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT chave_estrangeira;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT chave_estrangeira;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.funcionario (
    cpf character varying(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(40) NOT NULL,
    funcao character varying(11) NOT NULL,
    nivel character(1),
    superior_cpf character varying(11),
    CONSTRAINT funcionario_cpf_check CHECK ((length((cpf)::text) = 11)),
    CONSTRAINT funcionario_funcao_check CHECK ((((funcao)::text = 'LIMPEZA'::text) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT funcionario_nivel_check CHECK ((nivel = ANY (ARRAY['J'::bpchar, 'P'::bpchar, 'S'::bpchar]))),
    CONSTRAINT suplimp CHECK (((((funcao)::text = 'LIMPEZA'::text) AND (superior_cpf IS NOT NULL)) OR ((funcao)::text = 'SUP_LIMPEZA'::text)))
);


ALTER TABLE public.funcionario OWNER TO franciclaudio;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao text NOT NULL,
    func_resp_cpf character(11),
    status character(1) NOT NULL,
    prioridade smallint NOT NULL,
    CONSTRAINT func_resp_cpf CHECK ((length(func_resp_cpf) = 11)),
    CONSTRAINT podesernull CHECK ((((func_resp_cpf = NULL::bpchar) AND (status = 'P'::bpchar)) OR (func_resp_cpf IS NOT NULL))),
    CONSTRAINT status CHECK ((status = ANY (ARRAY['P'::bpchar, 'E'::bpchar, 'C'::bpchar])))
);


ALTER TABLE public.tarefas OWNER TO franciclaudio;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1981-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1982-05-07', 'Pedro da Silva', 'LIMPEZA', 'S', '12345678913');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '1983-05-07', 'Rafael da Silva', 'SUP_LIMPEZA', 'S', '12345678913');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '1984-05-07', 'Carlos da Silva', 'SUP_LIMPEZA', 'P', NULL);


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, status, prioridade) VALUES (2147483653, 'limpar portas do 1o andar', '12345678922', 'P', 2);
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, status, prioridade) VALUES (100, 'aparar a grama da área frontal', '12345678913', 'P', 2);
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, status, prioridade) VALUES (101, 'varrer o salão', '12345678913', 'C', 1);
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, status, prioridade) VALUES (102, 'deixar almoço pronto', '12345678913', 'E', 3);


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: chave_estrangeira; Type: FK CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT chave_estrangeira FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- Name: chave_estrangeira; Type: FK CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT chave_estrangeira FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

