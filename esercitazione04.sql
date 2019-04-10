-- Esercizio 1

EXPLAIN SELECT DISTINCT sede FROM corsostudi;

-- Esercizio 2

EXPLAIN SELECT DISTINCT I.nomeins, IE.id_facolta
FROM InsErogato AS IE
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
WHERE IE.annoaccademico = '2013/2014';

CREATE INDEX ie_ac ON inserogato(annoaccademico);
ANALYZE;

EXPLAIN SELECT DISTINCT I.nomeins, IE.id_facolta
FROM InsErogato AS IE
    INNER JOIN Insegn AS I ON I.id = IE.id_insegn
WHERE IE.annoaccademico = '2013/2014';

DROP INDEX IF EXISTS ie_ac;

-- Esercizio 3

EXPLAIN SELECT CS.codice, CS.nome, CS.abbreviazione
FROM CorsoStudi AS CS
WHERE CS.nome ILIKE '%lingue%';

-- non migliora con nessun indice perché dobbiamo verificare la 
-- sottostringa e gli indici funzionano solo su una parte "finale" 
-- della stringa

-- Esercizio 4

EXPLAIN SELECT IE.id, IE.modulo
FROM InsErogato AS IE
WHERE IE.modulo > 0
    AND IE.annoaccademico = '2010/2011'
    AND IE.id_facolta = 7;

CREATE INDEX ie_aa_m ON InsErogato(annoaccademico, modulo);
ANALYZE;

EXPLAIN SELECT IE.id, IE.modulo
FROM InsErogato AS IE
WHERE IE.modulo > 0
    AND IE.annoaccademico = '2010/2011'
    AND IE.id_facolta = 7;

DROP INDEX IF EXISTS ie_aa_m;

-- Esercizio 5

EXPLAIN SELECT DISTINCT I.nomeins, D.descrizione
FROM Insegn AS I
    INNER JOIN InsErogato AS IE ON IE.id_insegn = I.id
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
WHERE IE.annoaccademico = '2009/2010'
    AND IE.modulo = 0
    AND ( IE.crediti = 3
            OR IE.crediti = 5
            OR IE.crediti = 12
        );

CREATE INDEX ie_aa_cr ON inserogato(annoaccademico, crediti);
ANALYZE;

EXPLAIN SELECT DISTINCT I.nomeins, D.descrizione
FROM Insegn AS I
    INNER JOIN InsErogato AS IE ON IE.id_insegn = I.id
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
WHERE IE.annoaccademico = '2009/2010'
    AND IE.modulo = 0
    AND ( IE.crediti = 3
            OR IE.crediti = 5
            OR IE.crediti = 12
        );

DROP INDEX IF EXISTS ie_aa_cr;    

-- Esercizio 6

EXPLAIN SELECT I.nomeins, D.descrizione
FROM Insegn AS I
    INNER JOIN InsErogato AS IE ON IE.id_insegn = I.id
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
WHERE IE.annoaccademico = '2008/2009'
    AND IE.hamoduli = '0'
    AND IE.crediti > 9;

CREATE INDEX ie_aa_cr ON inserogato(annoaccademico, crediti);
ANALYZE;

EXPLAIN SELECT I.nomeins, D.descrizione
FROM Insegn AS I
    INNER JOIN InsErogato AS IE ON IE.id_insegn = I.id
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
WHERE IE.annoaccademico = '2008/2009'
    AND IE.hamoduli = '0'
    AND IE.crediti > 9;

DROP INDEX IF EXISTS ie_aa_cr;

-- Esercizio 7

EXPLAIN SELECT I.nomeins, D.descrizione, IE.crediti, IE.annierogazione
FROM Insegn AS I
    INNER JOIN InsErogato AS IE ON IE.id_insegn = I.id
    INNER JOIN CorsoStudi AS CS ON CS.id = IE.id_corsostudi
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
WHERE IE.annoaccademico = '2013/2014'
    AND IE.modulo = 0
    AND CS.nome = 'Informatica'
ORDER BY I.nomeins;

CREATE INDEX ie_aa ON inserogato(annoaccademico, modulo);
CREATE INDEX cs_nome ON corsostudi(nome);
ANALYZE;

EXPLAIN SELECT I.nomeins, D.descrizione, IE.crediti, IE.annierogazione
FROM Insegn AS I
    INNER JOIN InsErogato AS IE ON IE.id_insegn = I.id
    INNER JOIN CorsoStudi AS CS ON CS.id = IE.id_corsostudi
    INNER JOIN Discriminante AS D ON D.id = IE.id_discriminante
WHERE IE.annoaccademico = '2013/2014'
    AND IE.modulo = 0
    AND CS.nome = 'Informatica'
ORDER BY I.nomeins;

DROP INDEX IF EXISTS ie_aa;
DROP INDEX IF EXISTS cs_nome;

-- Esercizio 8

EXPLAIN SELECT MAX(IE.crediti)
FROM InsErogato AS IE
WHERE IE.annoaccademico = '2013/2014';

CREATE INDEX ie_aa ON inserogato(annoaccademico);
ANALYZE;

EXPLAIN SELECT MAX(IE.crediti)
FROM InsErogato AS IE
WHERE IE.annoaccademico = '2013/2014';

DROP INDEX IF EXISTS ie_aa;

-- Esercizio 9

EXPLAIN SELECT MAX(IE.crediti), MIN(IE.crediti)
FROM InsErogato AS IE
GROUP BY IE.annoaccademico;

-- nessun cambiamento, gli indici non variano il risultato

-- Esercizio 10

EXPLAIN SELECT CS.nome
FROM CorsoStudi AS CS
    INNER JOIN InsErogato AS IE ON CS.id = IE.id_corsostudi
WHERE CS.id NOT IN (
    SELECT IE2.id_corsostudi
    FROM InsErogato AS IE2
        INNER JOIN Insegn AS I ON I.id = IE2.id_insegn
    WHERE I.nomeins ILIKE '%matematica%'
);

-- nessun cambiamento

-- Esercizio 11

EXPLAIN SELECT SUM(IE.crediti), MAX(IE.crediti), MIN(IE.crediti)
FROM InsErogato AS IE
WHERE IE.modulo = 0
GROUP BY IE.annoaccademico, IE.id_corsostudi;

-- nessun cambiamento