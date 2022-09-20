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
    FOREIGN KEY(pessoa) REFERENCES pessoas(codigo),
    data_entrada        TEXT,
    descricao           TEXT,
    valor               REAL
);

CREATE TABLE IF NOT EXISTS saida(
    codigo              INTEGER PRIMARY KEY,
    pessoa              INTEGER,
    FOREIGN KEY(pessoa) REFERENCES pessoas(codigo),
    data_saida          TEXT,
    descricao           TEXT,
    valor               REAL
);