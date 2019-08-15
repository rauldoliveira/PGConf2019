/*
Créditos: Nikolay Shaplov
Postgres Professional
*/

DROP TABLE IF EXISTS bad_padding1;
DROP TABLE IF EXISTS good_padding1;

--Cria as tabelas
CREATE TABLE bad_padding1 (i1 INT, b1 BIGINT, i2 INT);
CREATE TABLE good_padding1 (i1 INT, i2 INT, b1 BIGINT);

--Insere Registros aleatrios
INSERT INTO bad_padding1 (i1, b1, i2)
SELECT 
    (random()*(2*10^9))::integer AS i1
    , (random()*(9*10^18))::bigint AS b1
    , (random()*(2*10^9))::integer AS i2
FROM generate_series(1,1000000) AS f(key);



--Insere os mesmos registros
INSERT INTO good_padding1 (i1, i2, b1)
SELECT i1, i2, b1
FROM bad_padding1;

ANALYSE bad_padding1;
ANALYSE good_padding1;

--Avalia a diferenÃ§a
SELECT relname, relpages, reltuples, relnatts
    ,pg_size_pretty(pg_total_relation_size(relname::regclass)) AS "TamTotalTable"
FROM pg_class C
WHERE 1=1
    AND relname IN ('bad_padding1','good_padding1')
;

