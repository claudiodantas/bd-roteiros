--
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

ALTER TABLE ONLY public.farmacias DROP CONSTRAINT fk_gerente;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT fk_funcionario;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT fk_farmacia;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT fk_endereco;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT fk_cliente;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_pkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.enderecos_farmacias DROP CONSTRAINT enderecos_farmacias_pkey;
ALTER TABLE ONLY public.enderecos_farmacias DROP CONSTRAINT enderecos_farmacias_bairro_key;
ALTER TABLE ONLY public.enderecos_clientes DROP CONSTRAINT enderecos_clientes_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
DROP TABLE public.vendas;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP TABLE public.farmacias;
DROP TABLE public.entregas;
DROP TABLE public.enderecos_farmacias;
DROP TABLE public.enderecos_clientes;
DROP TABLE public.clientes;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.clientes (
    pk_id integer NOT NULL,
    data_nasc timestamp without time zone NOT NULL,
    CONSTRAINT age CHECK ((age(data_nasc) >= age('2002-03-26 00:00:00-03'::timestamp with time zone, '2020-03-26 00:00:00-03'::timestamp with time zone)))
);


ALTER TABLE public.clientes OWNER TO franciclaudio;

--
-- Name: enderecos_clientes; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.enderecos_clientes (
    pk_id integer NOT NULL,
    tipo character(1),
    estado character(1),
    cidade character(1),
    bairro character(1),
    rua character(1),
    complemento character(1),
    CONSTRAINT enderecos_clientes_tipo_check CHECK ((tipo = ANY (ARRAY['r'::bpchar, 't'::bpchar, 'o'::bpchar])))
);


ALTER TABLE public.enderecos_clientes OWNER TO franciclaudio;

--
-- Name: enderecos_farmacias; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.enderecos_farmacias (
    pk_id integer NOT NULL,
    estado character(1),
    cidade character(1),
    bairro character(1)
);


ALTER TABLE public.enderecos_farmacias OWNER TO franciclaudio;

--
-- Name: entregas; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.entregas (
    pk_id integer NOT NULL,
    fk_farmacia integer NOT NULL,
    fk_cliente integer NOT NULL,
    fk_endereco integer NOT NULL
);


ALTER TABLE public.entregas OWNER TO franciclaudio;

--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.farmacias (
    pk_id integer NOT NULL,
    tipo character varying(1) NOT NULL,
    fk_gerente integer NOT NULL,
    fk_endereco integer NOT NULL,
    CONSTRAINT tipo CHECK (((tipo)::text = ANY ((ARRAY['s'::character varying, 'f'::character varying])::text[])))
);


ALTER TABLE public.farmacias OWNER TO franciclaudio;

--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.funcionarios (
    pk_id integer NOT NULL,
    fk_farmacia integer,
    tipo character(1) NOT NULL,
    CONSTRAINT tipo CHECK ((tipo = ANY (ARRAY['far'::bpchar, 'ven'::bpchar, 'ent'::bpchar, 'cai'::bpchar, 'adm'::bpchar])))
);


ALTER TABLE public.funcionarios OWNER TO franciclaudio;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.medicamentos (
    pk_id integer NOT NULL,
    receita boolean NOT NULL
);


ALTER TABLE public.medicamentos OWNER TO franciclaudio;

--
-- Name: vendas; Type: TABLE; Schema: public; Owner: franciclaudio
--

CREATE TABLE public.vendas (
    pk_id integer NOT NULL,
    fk_funcionario integer NOT NULL,
    cliente integer NOT NULL,
    fk_medicamento integer NOT NULL
);


ALTER TABLE public.vendas OWNER TO franciclaudio;

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--



--
-- Data for Name: enderecos_clientes; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--



--
-- Data for Name: enderecos_farmacias; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--



--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--



--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--



--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--



--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--



--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: franciclaudio
--



--
-- Name: clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (pk_id);


--
-- Name: enderecos_clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.enderecos_clientes
    ADD CONSTRAINT enderecos_clientes_pkey PRIMARY KEY (pk_id);


--
-- Name: enderecos_farmacias_bairro_key; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.enderecos_farmacias
    ADD CONSTRAINT enderecos_farmacias_bairro_key UNIQUE (bairro);


--
-- Name: enderecos_farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.enderecos_farmacias
    ADD CONSTRAINT enderecos_farmacias_pkey PRIMARY KEY (pk_id);


--
-- Name: entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (pk_id);


--
-- Name: farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_pkey PRIMARY KEY (pk_id);


--
-- Name: funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (pk_id);


--
-- Name: medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (pk_id);


--
-- Name: vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (pk_id);


--
-- Name: fk_cliente; Type: FK CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT fk_cliente FOREIGN KEY (fk_cliente) REFERENCES public.clientes(pk_id);


--
-- Name: fk_endereco; Type: FK CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT fk_endereco FOREIGN KEY (fk_endereco) REFERENCES public.enderecos_farmacias(pk_id);


--
-- Name: fk_farmacia; Type: FK CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT fk_farmacia FOREIGN KEY (fk_farmacia) REFERENCES public.farmacias(pk_id);


--
-- Name: fk_funcionario; Type: FK CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_funcionario FOREIGN KEY (fk_funcionario) REFERENCES public.funcionarios(pk_id);


--
-- Name: fk_gerente; Type: FK CONSTRAINT; Schema: public; Owner: franciclaudio
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT fk_gerente FOREIGN KEY (fk_gerente) REFERENCES public.funcionarios(pk_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

