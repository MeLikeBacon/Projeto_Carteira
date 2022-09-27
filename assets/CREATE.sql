CREATE TABLE IF NOT EXISTS pessoas(
    codigo              INTEGER PRIMARY KEY,
    nome                TEXT,
    email               TEXT,
    senha               TEXT,
    minimo              REAL,
    saldo               REAL
);

CREATE TABLE IF NOT EXISTS entrada(
    codigo              INTEGER PRIMARY KEY,
    pessoa              INTEGER,
    data_entrada        DATE,
    descricao           TEXT,
    valor               REAL,
    mov_type            BOOLEAN,
    FOREIGN KEY(pessoa) REFERENCES pessoas(codigo)
);

CREATE TABLE IF NOT EXISTS saida(
    codigo              INTEGER PRIMARY KEY,
    pessoa              INTEGER,
    data_saida          DATE,
    descricao           TEXT,
    valor               REAL,
    mov_type            BOOLEAN,
    FOREIGN KEY(pessoa) REFERENCES pessoas(codigo)
);