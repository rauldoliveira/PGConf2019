--Limpar o cache do SO
--sudo sh -c 'echo 3 >/proc/sys/vm/drop_caches'

CREATE EXTENSION IF NOT EXISTS pg_buffercache;
--- CREATE EXTENSION IF NOT EXISTS pgfincore;
CREATE EXTENSION IF NOT EXISTS PG_PREWARM;

SELECT setting as blocks, current_setting('block_size') as block_size
    , (setting::int * current_setting('block_size')::int) / (1024 * 1024) AS buffer_mb
FROM pg_settings WHERE name='shared_buffers';

SHOW 'shared_buffers';

SELECT * FROM public.pg_buffercache LIMIT 10;

WITH C AS (
SELECT (COUNT(*) * current_setting('block_size')::int) / (1024 * 1024) AS buffer_mb
    , (COUNT(CASE WHEN B.relfilenode IS NULL THEN 1 ELSE NULL END) * current_setting('block_size')::int) / (1024 * 1024)
        AS buffer_livre_mb
    , (COUNT(CASE WHEN B.relfilenode IS NOT NULL THEN 1 ELSE NULL END) * current_setting('block_size')::int) / (1024 * 1024)
        AS buffer_usado_mb
FROM pg_buffercache B
)
SELECT buffer_mb, buffer_livre_mb, buffer_usado_mb,  ROUND((buffer_usado_mb::numeric / buffer_mb) * 100,1) AS "% Usado"
FROM C

-- SELECT pg_prewarm('pgbench_accounts');

SELECT * FROM pgbench_accounts; 

WITH CSUM AS (
SELECT COUNT(*) AS QTD
FROM public.pg_buffercache
)
SELECT usagecount,COUNT(*)--, QTD
    ,TO_CHAR(((COUNT(*) / CSUM.QTD::numeric) * 100.0) ::float, '990.00')::numeric(5,2) AS pct
FROM pg_buffercache
CROSS JOIN CSUM
GROUP BY usagecount, QTD
ORDER BY usagecount;

