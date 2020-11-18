-- SCHEMA
-- tables
-- Table: Equipe
CREATE TABLE Equipe (
    id_equipe int  NOT NULL,
    nome varchar(20)  NOT NULL,
    tecnico varchar(20)  NULL,
    CONSTRAINT Equipe_pk PRIMARY KEY (id_equipe)
);

-- Table: JOGA
CREATE TABLE JOGA (
    cpf_jogador char(11)  NOT NULL,
    id_partida int  NOT NULL,
    posicao varchar(20)  NOT NULL,
    CONSTRAINT JOGA_pk PRIMARY KEY (cpf_jogador,id_partida,posicao)
);

-- Table: Jogador
CREATE TABLE Jogador (
    cpf char(11)  NOT NULL,
    nome varchar(30)  NOT NULL,
    id_equipe int  NOT NULL,
    CONSTRAINT Jogador_pk PRIMARY KEY (cpf)
);

-- Table: PARTICIPA
CREATE TABLE PARTICIPA (
    id_equipe int  NOT NULL,
    id_partida int  NOT NULL,
    CONSTRAINT PARTICIPA_pk PRIMARY KEY (id_equipe,id_partida)
);

-- Table: Partida
CREATE TABLE Partida (
    id_partida int  NOT NULL,
    horario time  NOT NULL,
    data_partida date  NOT NULL,
    id_equipe1 int  NOT NULL,
    id_equipe2 int  NOT NULL,
    gols_equipe1 int  NOT NULL,
    gols_equipe2 int  NOT NULL,
    CONSTRAINT Partida_pk PRIMARY KEY (id_partida)
);

-- foreign keys
-- Reference: Jogador_Equipe (table: Jogador)
ALTER TABLE Jogador ADD CONSTRAINT Jogador_Equipe
    FOREIGN KEY (id_equipe)
    REFERENCES Equipe (id_equipe)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Jogador_joga (table: JOGA)
ALTER TABLE JOGA ADD CONSTRAINT Jogador_joga
    FOREIGN KEY (cpf_jogador)
    REFERENCES Jogador (cpf)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Partida_Participa (table: PARTICIPA)
ALTER TABLE PARTICIPA ADD CONSTRAINT Partida_Participa
    FOREIGN KEY (id_partida)
    REFERENCES Partida (id_partida)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Partida_possui (table: JOGA)
ALTER TABLE JOGA ADD CONSTRAINT Partida_possui
    FOREIGN KEY (id_partida)
    REFERENCES Partida (id_partida)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Equipe_Participa (table: PARTICIPA)
ALTER TABLE PARTICIPA ADD CONSTRAINT Equipe_Participa
    FOREIGN KEY (id_equipe)
    REFERENCES Equipe (id_equipe)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;



--COMANDOS PARA POPULAR O BD
-- Equipe -----------------------
-- equipe sem tecnico
INSERT INTO Equipe (id_equipe, nome, tecnico)
VALUES (1, 'Sao Paulo');
-- equipe com tecnico
INSERT INTO Equipe (id_equipe, nome, tecnico)
VALUES (2, 'Sao Paulo', 'Tecnico1');
INSERT INTO Equipe (id_equipe, nome, tecnico)
VALUES (3, 'Sao Paulo', 'Tecnico2');


-- Jogador ----------------------
-- Jogador sem equipe
INSERT INTO Jogador (cpf, nome, id_equipe)
VALUES ('12345678910', 'Joao');
-- Jogador com equipe
INSERT INTO Jogador (cpf, nome, id_equipe)
VALUES ('12345678911', 'Marcelo', 1);
INSERT INTO Jogador (cpf, nome, id_equipe)
VALUES ('12345678912', 'Pedro', 2);


-- Partida ---------------------
-- Equipe 2 ganhou
INSERT INTO Partida (id_partida, horario, data, id_equipe1, id_equipe2, gols_equipe1, gols_equipe2)
VALUES (1, '04:05', '10/10/2020', 1, 2, 0, 2);
-- Equipe 1 ganhou
INSERT INTO Partida (id_partida, horario, data, id_equipe1, id_equipe2, gols_equipe1, gols_equipe2)
VALUES (2, '04:05', '09/10/2020', 1, 2, 2, 0);
-- Empate
INSERT INTO Partida (id_partida, horario, data, id_equipe1, id_equipe2, gols_equipe1, gols_equipe2)
VALUES (3, '04:05', '08/10/2020', 1, 2, 0, 0);


--JOGA
INSERT INTO JOGA (cpf_jogador, id_partida, posicao)
VALUES ('12345678911', 1, 'volante');
INSERT INTO JOGA (cpf_jogador, id_partida, posicao)
VALUES ('12345678911', 1, 'atacante');


--PARTICIPA
INSERT INTO PARTICIPA (id_equipe, id_partida)
VALUES (1, 1);
INSERT INTO PARTICIPA (id_equipe, id_partida)
VALUES (1, 2);