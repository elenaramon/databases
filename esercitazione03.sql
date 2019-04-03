-- Esercizio 1 - corretto

SELECT DISTINCT P.id, P.nome, P.cognome
FROM Persona AS P 
    INNER JOIN Docenza AS D ON D.id_persona = P.id 
    INNER JOIN InsErogato AS IE ON IE.id = D.id_inserogato
WHERE IE.annoaccademico = '2010/2011'
    AND EXISTS (
        SELECT 1
        FROM Persona AS P2 
            INNER JOIN Docenza AS D2 ON D2.id_persona = P2.id
            INNER JOIN InsErogato AS IE2 ON IE2.id = D2.id_inserogato
        WHERE IE2.id_corsostudi <> IE.id_corsostudi
            AND IE2.annoaccademico = '2010/2011'
            AND P2.id = P.id
    )
ORDER BY P.id
LIMIT 5 OFFSET 49;

-- Esercizio 2 - corretto 5 righe

SELECT P.nome, P.cognome, P.telefono
FROM Persona AS P 
    INNER JOIN Docenza AS D ON D.id_persona = P.id
    INNER JOIN InsErogato AS IE ON IE.id = D.id_inserogato    
WHERE IE.annoaccademico = '2009/2010'
    AND IE.modulo = 0
    AND IE.id_corsostudi = 4
    AND NOT EXISTS (
        SELECT 1
        FROM InsErogato AS IE2 
            INNER JOIN Docenza AS D2 ON D2.id_inserogato = IE2.id
            INNER JOIN Persona AS P2 ON P2.id = D2.id_persona
            INNER JOIN Insegn AS I ON I.id = IE2.id_insegn
        WHERE I.nomeins = 'Programmazione'
            AND IE2.id_corsostudi = 4
            AND P2.id = P.id
    )
ORDER BY P.cognome;    

-- Esercizio 3 - corretto 1031 righe

SELECT DISTINCT P.id, P.nome, P.cognome
FROM Persona AS P 
    INNER JOIN Docenza AS D ON D.id_persona = P.id
    INNER JOIN InsErogato AS IE ON IE.id = D.id_inserogato
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
WHERE IE.annoaccademico = '2010/2011'     
    AND I.nomeins NOT IN (
        SELECT I2.nomeins
        FROM Docenza AS D2
            INNER JOIN InsErogato AS IE2 ON IE2.id = D2.id_inserogato
            INNER JOIN Insegn AS I2 ON I2.id = IE2.id_insegn
        WHERE IE2.annoaccademico = '2009/2010'
            AND D2.id_persona = P.id
    )
ORDER BY P.id;    

-- Esercizio 4 - corretto 3 righe

SELECT PL.abbreviazione, PD.discriminante, PD.inizio, PD.fine, COUNT(*) AS insprimosem
FROM PeriodoDid AS PD
    INNER JOIN PeriodoLez AS PL ON PL.id = PD.id
    INNER JOIN InsInPeriodo AS IIP ON PD.id = IIP.id_periodolez    
WHERE (PD.descrizione LIKE 'I semestre%'
        OR PD.descrizione LIKE 'Primo semestre%')
        AND PD.annoaccademico = '2010/2011'
GROUP BY PL.abbreviazione, PD.discriminante, PD.inizio, PD.fine
ORDER BY PD.inizio, PD.fine;        

-- Esericizio 5 - corretto 8 righe

SELECT F.nome, COUNT(*) AS numeroUnitaLogistiche, SUM(IE.crediti) AS totCrediti
FROM Facolta AS F 
    INNER JOIN InsErogato AS IE ON IE.id_facolta = F.id
WHERE IE.annoaccademico = '2010/2011'
    AND IE.modulo < 0
GROUP BY F.id;

-- Esercizio 6 - corretto 33 righe

SELECT CS.nome, COUNT(*) AS corsiConModuli
FROM CorsoStudi AS CS
    INNER JOIN InsErogato AS IE ON IE.id_corsostudi = CS.id
WHERE IE.annoaccademico = '2010/2011'
    AND IE.hamoduli > '0'
    AND CS.id NOT IN (
        SELECT CS1.id
        FROM CorsoStudi AS CS1 
            INNER JOIN CorsoInFacolta AS CIF ON CIF.id_corsostudi = CS.id
            INNER JOIN Facolta AS F ON F.id = CIF.id_facolta
        WHERE F.nome = 'Medicina e Chirurgia'
    )
GROUP BY CS.id
ORDER BY CS.nome;   

-- Esercizio 7 - corretto 14 righe

SELECT DISTINCT IE.id_insegn
FROM CorsoStudi AS CS 
    INNER JOIN InsErogato AS IE ON IE.id_corsostudi = CS.id
WHERE CS.id = 4
    AND IE.id_insegn NOT IN (
        SELECT IE2.id_insegn
        FROM CorsoStudi AS CS2
            INNER JOIN InsErogato AS IE2 ON IE2.id_corsostudi = CS2.id
            INNER JOIN InsInPeriodo AS IIP ON IIP.id_inserogato = IE2.id
            INNER JOIN PeriodoLez AS PL ON IIP.id_periodolez = PL.id
        WHERE PL.abbreviazione LIKE '2%'
            AND CS2.id = 4
    );

-- Esercizio 8 - corretta 10 righe (anche risultato)

DROP VIEW IF EXISTS TotOreLez;

CREATE TEMP VIEW TotOreLez AS 
    SELECT P.nome, P.cognome, F.id, F.nome AS nomefacolta, SUM(D.orelez) AS orelez
    FROM Facolta AS F 
        INNER JOIN InsErogato AS IE ON F.id = IE.id_facolta
        INNER JOIN Docenza AS D ON D.id_inserogato = IE.id
        INNER JOIN Persona AS P ON P.id = D.id_persona
    WHERE IE.annoaccademico = '2009/2010'
    GROUP BY F.id, P.id;

SELECT TOL.cognome, TOL.nomefacolta, TOL.orelez
FROM TotOreLez AS TOL
WHERE TOL.orelez = ANY (
    SELECT MAX(TOL2.orelez)
    FROM TotOreLez AS TOL2
    WHERE TOL.id = TOL2.id
)
ORDER BY TOL.cognome;

-- Esercizio 9 - corretta 22 righe (anche risultato)

SELECT DISTINCT I.nomeins, I.id
FROM InsErogato AS IE 
    INNER JOIN Docenza AS D ON D.id_inserogato = IE.id
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
WHERE IE.annoaccademico = '2009/2010'
    AND IE.modulo = 0
    AND IE.id_corsostudi = 240
    AND D.id_persona NOT IN (
        SELECT P.id
        FROM  Persona AS P
        WHERE (P.nome = 'Roberto'
            OR P.nome = 'Alberto'
            OR P.nome = 'Luca'
            OR P.nome = 'Massimo')
    )  

INTERSECT ALL

SELECT DISTINCT I.nomeins, I.id
FROM InsErogato AS IE 
    INNER JOIN Docenza AS D ON D.id_inserogato = IE.id
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
WHERE IE.annoaccademico = '2010/2011'
    AND IE.modulo = 0
    AND IE.id_corsostudi = 240
    AND D.id_persona NOT IN (
        SELECT P.id
        FROM  Persona AS P
        WHERE (P.nome = 'Roberto'
            OR P.nome = 'Alberto'
            OR P.nome = 'Luca'
            OR P.nome = 'Massimo')
    )
ORDER BY nomeins;

-- Esercizio 10 - corretta 8 righe (anche risultato)

SELECT DISTINCT I.nomeins, IE.nomeunita
FROM InsErogato AS IE 
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
    INNER JOIN Lezione AS L1 ON L1.id_inserogato = IE.id
WHERE IE.id_corsostudi = 420
    AND IE.annoaccademico = '2010/2011'
    AND IE.modulo < 0
    AND (L1.giorno = 2 OR L1.giorno = 3)
    AND IE.id NOT IN (
        SELECT IE2.id
        FROM InsErogato AS IE2 
            INNER JOIN Lezione AS L ON L.id_inserogato = IE2.id
            INNER JOIN Lezione AS L2 ON L2.id_inserogato = IE2.id
        WHERE IE2.id_corsostudi = 420
            AND IE2.modulo < 0
            AND IE2.annoaccademico = '2010/2011'
            AND L.giorno = 2
            AND L2.giorno = 3
    )
ORDER BY I.nomeins;

-- Esercizio 11 - corretto 572 righe

SELECT DISTINCT CS.id, CS.nome
FROM CorsoStudi AS CS
WHERE CS.id NOT IN (
    SELECT CS2.id
    FROM InsErogato AS IE2
        INNER JOIN CorsoStudi AS CS2 ON CS2.id = IE2.id_corsostudi
        INNER JOIN Insegn AS I ON I.id = IE2.id_insegn
    WHERE I.nomeins ILIKE '%matematica%'
)
ORDER BY CS.id;

-- Esercizio 12 - corretto 535 righe (anche risultato)

SELECT DISTINCT I.nomeins, P.nome, P.cognome
FROM InsErogato AS IE 
    INNER JOIN CorsoStudi AS CS ON IE.id_corsostudi = CS.id
    INNER JOIN CorsoInFacolta AS CIF ON CIF.id_corsostudi = CS.id
    INNER JOIN Facolta AS F ON F.id = CIF.id_facolta
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
    INNER JOIN Docenza AS D ON D.id_inserogato = IE.id
    INNER JOIN Persona AS P ON P.id = D.id_persona
WHERE IE.modulo = 0
    AND F.nome ILIKE '%Scienze Matematiche Fisiche e Naturali%'    
    AND SUBSTRING(IE.annoaccademico, 6, 4) = ANY (
        SELECT SUBSTRING(IE2.annoaccademico, 1, 4)
        FROM InsErogato AS IE2 
            INNER JOIN CorsoStudi AS CS2 ON IE2.id_corsostudi = CS2.id
            INNER JOIN CorsoInFacolta AS CIF2 ON CIF2.id_corsostudi = CS2.id
            INNER JOIN Facolta AS F2 ON F2.id = CIF2.id_facolta
            INNER JOIN Docenza AS D2 ON D2.id_inserogato = IE2.id
            INNER JOIN Persona AS P2 ON P2.id = D2.id_persona
            INNER JOIN Insegn AS I2 ON I2.id = IE2.id_insegn
        WHERE P.id = P2.id
            AND I.id = I2.id
            AND IE2.modulo = 0
            AND F2.nome ILIKE '%Scienze Matematiche Fisiche e Naturali%'

    )
ORDER BY I.nomeins
;

-- Esercizio 13 - corretto 42 righe

SELECT COUNT(*), STS.nomestruttura, STS.fax
FROM CorsoStudi AS CS 
    INNER JOIN StrutturaServizio AS STS ON STS.id = CS.id_segreteria
GROUP BY STS.id;

-- Esercizio 14 - 

DROP VIEW IF EXISTS oreTotali;
DROP VIEW IF EXISTS sumCrediti;

CREATE TEMP VIEW oreTotali AS
    SELECT AVG(D.creditilez) AS media
    FROM InsErogato AS IE
        INNER JOIN Docenza AS D ON D.id_inserogato = IE.id
        INNER JOIN Persona AS P ON D.id_persona = P.id
    WHERE IE.annoaccademico = '2010/2011'
        AND D.creditilez > 3;

CREATE TEMP VIEW sumCrediti AS
    SELECT SUM(D.creditilez) AS somma, D.id_persona
    FROM InsErogato AS IE
        INNER JOIN Docenza AS D ON D.id_inserogato = IE.id
        INNER JOIN Persona AS P ON D.id_persona = P.id
    WHERE IE.annoaccademico = '2010/2011'
        AND D.creditilez > 3
    GROUP BY D.id_persona;     

SELECT DISTINCT SC.somma, P.nome, P.cognome
FROM oreTotali AS OT, InsErogato AS IE
    INNER JOIN Docenza AS D ON D.id_inserogato = IE.id    
    INNER JOIN sumCrediti AS SC ON SC.id_persona = D.id_persona
    INNER JOIN Persona AS P ON P.id = SC.id_persona
WHERE SC.somma > OT.media;

-- Esercizio 15 

SELECT DISTINCT P.id, P.nome, P.cognome, COUNT(*) AS numero
FROM Persona AS P
    INNER JOIN Docenza AS D ON D.id_persona = P.id
    INNER JOIN InsErogato AS IE ON IE.id = D.id_inserogato
WHERE IE.annoaccademico = '2005/2006'
GROUP BY P.id, P.nome, P.cognome

UNION

SELECT DISTINCT P.id, P.nome, P.cognome, 0 AS numero
FROM Persona AS P
    INNER JOIN Docenza AS D ON D.id_persona = P.id
WHERE P.id NOT IN (
    SELECT DISTINCT P.id
    FROM Persona AS P
        INNER JOIN Docenza AS D ON D.id_persona = P.id
        INNER JOIN InsErogato AS IE ON IE.id = D.id_inserogato
    WHERE IE.annoaccademico = '2005/2006'
)

ORDER BY id;
