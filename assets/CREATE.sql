CREATE TABLE IF NOT EXISTS pessoas(
    codigo              INTEGER PRIMARY KEY,
    nome                TEXT,
    email               TEXT,
    senha               TEXT,
    minimo              REAL,
    saldo               REAL,
    tipo                TEXT
);

CREATE TABLE IF NOT EXISTS entrada(
    codigo              INTEGER PRIMARY KEY,
    pessoa              INTEGER,
    responsavel         INTEGER,
    data_entrada        DATE,
    descricao           TEXT,
    valor               REAL,
    mov_type            BOOLEAN,
    FOREIGN KEY(pessoa)         REFERENCES pessoas(codigo),
    FOREIGN KEY(responsavel)    REFERENCES pessoas(codigo)
);

CREATE TABLE IF NOT EXISTS saida(
    codigo              INTEGER PRIMARY KEY,
    pessoa              INTEGER,
    responsavel         INTEGER,
    data_saida          DATE,
    descricao           TEXT,
    valor               REAL,
    mov_type            BOOLEAN,
    FOREIGN KEY(pessoa)         REFERENCES pessoas(codigo),
    FOREIGN KEY(responsavel)    REFERENCES pessoas(codigo)
);

INSERT INTO pessoas(codigo,nome,email,senha,minimo,saldo,tipo) SELECT 0, 'admin', 'adm', '27', 0, 0, 'adm' WHERE NOT EXISTS(SELECT 1 FROM pessoas WHERE codigo = 0);