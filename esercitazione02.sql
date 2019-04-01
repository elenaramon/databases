-- Esercizio 1 - corretta 635 righe

SELECT COUNT(*)
FROM CorsoStudi;

-- Esercizio 2 - corretta 8 righe

SELECT nome, codice, indirizzo, id_preside_persona
FROM Facolta;

-- Esercizio 3 - corretta 211 righe + 5 consecutive
-- LIMIT <N> OFFSET <M> prende le primi N righe e "spazza via" le prime M

SELECT DISTINCT CS.nome, F.nome
FROM InsErogato AS IE 
    INNER JOIN CorsoStudi AS CS ON IE.id_corsostudi = CS.id
    INNER JOIN CorsoInFacolta AS CF ON CF.id_corsostudi = CS.id
    INNER JOIN Facolta AS F ON F.id = CF.id_facolta
WHERE IE.annoaccademico = '2010/2011'
ORDER BY CS.nome
LIMIT 5 OFFSET 9;

-- Esercizio 4 - corretto 236 righe

SELECT CS.nome, CS.codice, CS.abbreviazione
FROM CorsoStudi AS CS
    INNER JOIN CorsoInFacolta AS CF ON CF.id_corsostudi = CS.id
    INNER JOIN Facolta AS F ON F.id = CF.id_facolta
WHERE F.nome = 'Medicina e Chirurgia';

-- Esercizio 5 - corretto 16 righe

SELECT nome, codice, abbreviazione
FROM CorsoStudi
WHERE nome ILIKE '%lingue%';

-- Esercizio 6 - corretto 48 righe

SELECT DISTINCT sede
FROM CorsoStudi;

-- Esercizio 7 - corretto 336 righe (per avere solo i moduli la risposta è 27 righe)

SELECT DISTINCT I.nomeins, D.descrizione, IE.nomemodulo, IE.modulo
FROM InsErogato AS IE 
    INNER JOIN CorsoStudi AS CS ON CS.id = IE.id_corsostudi
    INNER JOIN CorsoInFacolta AS CF ON CF.id_corsostudi = CS.id
    INNER JOIN Facolta AS F ON CF.id_facolta = F.id
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
WHERE IE.annoaccademico = '2010/2011' AND F.nome = 'Economia';

-- Esercizio 8 - correto 724 righe

SELECT DISTINCT I.nomeins, D.descrizione
FROM InsErogato AS IE
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn 
WHERE IE.annoaccademico = '2009/2010' 
    AND IE.modulo = 0
    AND (IE.crediti = 3 OR IE.crediti = 5 OR IE.crediti = 12)
ORDER BY descrizione; 

-- Esercizio 9 - corretta 1218 righe

SELECT IE.id, I.nomeins, D.descrizione
FROM InsErogato AS IE 
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
WHERE IE.annoaccademico = '2008/2009' 
    AND IE.modulo = 0
    AND IE.crediti > 9
ORDER BY I.nomeins
LIMIT 5 OFFSET 1022;

-- Esercizio 10 - corretto 26 righe

SELECT DISTINCT I.nomeins, D.descrizione, IE.crediti, IE.annierogazione, CS.nome
FROM InsErogato AS IE 
    INNER JOIN CorsoStudi AS CS ON IE.id_corsostudi = CS.id
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
WHERE IE.annoaccademico = '2010/2011'
    AND CS.nome = 'Laurea in Informatica'
    AND IE.modulo = 0
ORDER BY I.nomeins;

-- Esercizio 11 - corretto 1 riga 180

SELECT MAX(IE.crediti) AS Crediti
FROM InsErogato AS IE
WHERE IE.annoaccademico = '2010/2011';

-- Esercizio 12 - corretto 16 righe (ma il risultato) 

SELECT MAX(IE.crediti) AS Massimo, MIN(IE.crediti) AS Minimo
FROM InsErogato AS IE
GROUP BY IE.annoaccademico;

-- Esercizio 13 - corretto 1587 righe (anche il risultato)

SELECT SUM(IE.crediti) AS Crediti, MAX(IE.crediti) AS Massimo, MIN(IE.crediti) AS Minimo
FROM InsErogato AS IE
    INNER JOIN CorsoStudi AS C ON C.id = IE.id_corsostudi
WHERE  IE.modulo = 0
GROUP BY IE.annoaccademico, IE.id_corsostudi, C.nome
ORDER BY IE.annoaccademico;

-- Esercizio 14 - 19 righe

SELECT COUNT(*)
FROM InsErogato AS IE
    INNER JOIN CorsoStudi AS CS ON CS.id = IE.id_corsostudi
    INNER JOIN CorsoInFacolta AS CF ON CF.id_corsostudi = CS.id
    INNER JOIN Facolta AS F ON F.id = CF.id_facolta
WHERE IE.annoaccademico = '2009/2010'
    AND F.nome = 'Scienze matematiche fisiche e naturali'
    AND IE.modulo = 0
GROUP BY IE.id_corsostudi;    

-- Esercizio 14 - 21 righe

SELECT COUNT(*)
FROM InsErogato AS IE   
    INNER JOIN Facolta AS F ON IE.id_facolta = F.id
WHERE IE.modulo = 0 
    AND IE.annoaccademico = '2009/2010'    
    AND F.nome = 'Scienze matematiche fisiche e naturali'
GROUP BY IE.id_corsostudi;    

-- Esercizio 15 - corretto 197 righe e risultato

SELECT DISTINCT CS.nome, CS.durataAnni
FROM InsErogato AS IE 
    INNER JOIN CorsoStudi AS CS ON CS.id = IE.id_corsostudi
WHERE IE.annoaccademico = '2010/2011'
    AND (
        IE.crediti = 4 
        OR IE.crediti = 6 
        OR IE.crediti = 8
        OR IE.crediti = 10
        OR IE.crediti = 12
        OR (IE.creditilab >= 10 AND IE.creditilab < 15)    
        );
    