-- DROP TABLE IF EXISTS tabela_ringbuffer;
-- SELECT * FROM tabela_ringbuffer
CREATE TABLE IF NOT EXISTS tabela_ringbuffer
( id serial
, numero INT
, texto VARCHAR(20)
, datas TIMESTAMP
);

INSERT INTO tabela_ringbuffer (numero, texto, datas)
SELECT 
    (random()*(2*10^9))::integer AS inteiro
    , substr('abcdefghijklmnopqrstuvwxyz',1,(random()*10)::integer)::varchar(20)
    , (NOW() - random() * interval '1 year') AS datetime
FROM generate_series(1,1000000) AS f(key)
--ORDER BY random() * 1.0 --For random ordering 
;
-- 1 milhao de linhas: ~20 segundos
-- 10 milhoes: 1 minuto

SELECT pg_table_size('tabela_ringbuffer');
SELECT pg_size_pretty(pg_table_size('tabela_ringbuffer'));

--Fazer em duas sessões e ver o resultado:
SELECT * FROM tabela_ringbuffer;

/*----------------------------------------------------------------------------------
    Demo 2 
----------------------------------------------------------------------------------*/

DROP TABLE IF EXISTS tabela;

CREATE TABLE IF NOT EXISTS tabela (c1 integer, c2 text);
INSERT INTO tabela
SELECT i, md5(random()::text)
FROM generate_series(1, 1000000) AS i;

--  systemctl stop postgresql-11 && sync && echo 3 > /proc/sys/vm/drop_caches && sync && systemctl start postgresql-11

SELECT 1;

EXPLAIN (ANALYSE, BUFFERS) SELECT * FROM tabela;