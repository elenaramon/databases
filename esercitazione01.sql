-- Cancello tutte le tabelle
DROP TABLE IF EXISTS Museo CASCADE;
DROP TABLE IF EXISTS Opera CASCADE;
DROP TABLE IF EXISTS Mostra CASCADE;
DROP TABLE IF EXISTS Orario CASCADE;
-- Cancello i domini esistenti
DROP DOMAIN IF EXISTS giorniSettimana;
DROP DOMAIN IF EXISTS dateYear;

-- Esercizio 1
-- Creo tutte le tabelle

-- Creo dominio per i giorni della settimana
CREATE DOMAIN giorniSettimana AS VARCHAR (9) CHECK (VALUE IN ('lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato', 'domenica'));

-- Creo il dominio dall'anno
CREATE DOMAIN dateYear AS INTEGER CHECK(VALUE <= EXTRACT( YEAR FROM NOW() ));

CREATE TABLE Museo (
    -- è chiave primaria 
    -- è una stringa di lunghezza variabile
    -- massima 30
    -- minima 4
    -- valore di default MuseoVeronese
    nome VARCHAR (30) DEFAULT 'MuseoVeronese' CHECK (CHAR_LENGTH(nome) >= 4),
    -- è chiave primaria
    -- è una stringa di lunghezza variabile
    -- valore di defualt Verona
    città VARCHAR (20) DEFAULT 'Verona', 
    -- è una stringa di lunghezza variabile
    -- minima 7
    indirizzo VARCHAR CHECK (CHAR_LENGTH(indirizzo) >= 7),
    -- è una stringa di lunghezza variabile
    -- massima 13
    -- minima 4
    -- deve essere corrispondere alla regex dei numeri di telefono
    numeroTelefono VARCHAR (15) CHECK (numeroTelefono SIMILAR TO '([+]([0-9]){2,4})?([0-9]){4,10}'),
    -- ha come dominio quello creato
    giornoChiusura giorniSettimana NOT NULL,
    -- numero con precisione 5
    -- numero massimo di cifre decimali 2
    -- default 10
    prezzo NUMERIC (5, 2) NOT NULL DEFAULT 10,    
    PRIMARY KEY (nome, città)
);

CREATE TABLE Opera (
    -- stringa di lunghezza variabile
    -- massima 30
    -- minima ipotizzata 2
    nome VARCHAR (30) CHECK (CHAR_LENGTH (nome) >= 2),
    -- stringa di lunghezza variabile
    -- massima 20
    -- minima 1 (cognome più corto del mondo)
    cognomeAutore VARCHAR (20) CHECK (CHAR_LENGTH (cognomeAutore) >= 1),
    -- stringa di lunghezza variabile
    -- massima 20
    -- minima 1 (nome più corto de mondo)
    nomeAutore VARCHAR (20) CHECK (CHAR_LENGTH (nomeAutore) >= 1),
    -- chiave esportata
    museo VARCHAR (30),
    -- chiave esportata
    città VARCHAR (20),
    -- stringa di lunghezza variabile
    -- minima 6 ipotesi (BAROCCA lunghezza 7)
    epoca VARCHAR CHECK(CHAR_LENGTH (epoca) >= 6),
    -- dominio personalizzato
    anno dateYear,
    PRIMARY KEY (nome, cognomeAutore, nomeAutore),
    FOREIGN KEY (museo, città) REFERENCES Museo (nome, città)
);

CREATE TABLE Mostra (
    -- chiave primaria
    -- stringa di lunghezza variabile
    -- massimo 30
    -- minimo 2 ipotesi
    titolo VARCHAR (30) CHECK (CHAR_LENGTH(titolo) >= 2),
    -- chiave primaria
    inizio DATE,
    -- deve essere successiva alla data di inizio    
    fine DATE NOT NULL,
    -- chiave esportata
    museo VARCHAR (30),
    -- chiave esportata
    città VARCHAR (20),
    -- numero con precisione 5
    -- numero massimo di cifre decimali 2
    prezzo NUMERIC (5, 2),   
    CHECK (fine >= inizio), 
    PRIMARY KEY (titolo, inizio),
    FOREIGN KEY (museo, città) REFERENCES Museo (nome, città)
);

CREATE TABLE Orario (
    progressivo INTEGER PRIMARY KEY,
    -- chiave esterna
    museo VARCHAR (30) NOT NULL,
    -- chiave esterna
    città VARCHAR (20) NOT NULL,
    -- ha come dominio quello creato
    giorno giorniSettimana NOT NULL,
    orarioApertura TIME WITH TIME ZONE DEFAULT '09:00 CET',
    -- deve essere maggiore dell'orario di apertura
    orarioChiusura TIME WITH TIME ZONE DEFAULT '19:00 CET',
    CHECK(orarioChiusura > orarioApertura),
    FOREIGN KEY (museo, città) REFERENCES Museo (nome, città)
);

-- Esercizio 2

INSERT INTO Museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo) VALUES ('Arena', 'Verona', 'piazza Bra', 0458003204, 'martedì', 20);
INSERT INTO Museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo) VALUES ('CastelVecchio', 'Verona', 'Corso Castelvecchio', 045594734, 'lunedì', 15);

-- Esercizio 3

INSERT INTO Opera (nome, cognomeAutore, nomeAutore, museo, città, epoca, anno) VALUES ('Dipinto', 'Lippi', 'Filippo', 'CastelVecchio', 'Verona', 'millequattrocento', '1423');
INSERT INTO Opera (nome, cognomeAutore, nomeAutore, museo, città, epoca, anno) VALUES ('AltroDipinto', 'Caliari', 'Paolo', 'Arena', 'Verona', 'millecinquecento', '1548');
INSERT INTO Opera (nome, cognomeAutore, nomeAutore, museo, città, epoca, anno) VALUES ('Fanciullo', 'Caroto', 'Giovan Francesco', 'CastelVecchio', 'Verona', 'millecinquecento', '1560');
INSERT INTO Mostra (titolo, inizio, fine, museo, città, prezzo) VALUES ('Canova', '28/03/2019', '31/03/2019', 'CastelVecchio', 'Verona', '15');
INSERT INTO Mostra (titolo, inizio, fine, museo, città, prezzo) VALUES ('Fiori', '26/05/2019', '05/07/2019', 'Arena', 'Verona', '10');
INSERT INTO Mostra (titolo, inizio, fine, museo, città, prezzo) VALUES ('Leonardo da Vinci', '29/03/2019', '24/06/2019', 'CastelVecchio', 'Verona', '20');

-- Ese  rcizio 4

-- INSERT INTO Museo (nome, indirizzo, numeroTelefono, giornoChiusura, prezzo) VALUES ('aaa', 'via', 045, 'mar', 1);

-- Esercizio 5

ALTER TABLE Museo ADD COLUMN sitoInternet VARCHAR CHECK (sitoInternet SIMILAR TO '([w]){3}[.]([a-zA-Z0-9]){3}[.]([a-z]){2,3}');

-- Esercizio 6

ALTER TABLE Mostra RENAME COLUMN prezzo TO prezzoIntero;
ALTER TABLE Mostra ADD COLUMN prezzoRidotto NUMERIC(5, 2) DEFAULT 5;
ALTER TABLE Mostra ADD CHECK (prezzoRidotto < prezzoIntero);

-- Esercizio 7

UPDATE Museo SET prezzo = prezzo + 1;

-- Esercizio 8

UPDATE Mostra SET prezzoRidotto = prezzoRidotto + 1 WHERE prezzoIntero < 15;

