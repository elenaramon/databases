-- Esempio di file comando SQL
-- cancello la tabella
DROP TABLE pippo;
-- creo la tabella
CREATE TABLE pippo (
    id INTEGER PRIMARY KEY,
    nome VARCHAR NOT NULL UNIQUE
);
