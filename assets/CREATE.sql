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
    data_entrada        TEXT,
    descricao           TEXT,
    valor               REAL,
    FOREIGN KEY(pessoa) REFERENCES pessoas(codigo)
);

CREATE TABLE IF NOT EXISTS saida(
    codigo              INTEGER PRIMARY KEY,
    pessoa              INTEGER,
    data_saida          TEXT,
    descricao           TEXT,
    valor               REAL,
    FOREIGN KEY(pessoa) REFERENCES pessoas(codigo)
);