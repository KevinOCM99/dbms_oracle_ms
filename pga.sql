set lines 120;
show parameter pga;

-- Individual values.
COLUMN name FORMAT A50
COLUMN value FORMAT A15

SELECT name, value
FROM   v$parameter
WHERE  name IN ('pga_aggregate_target', 'sga_target')
UNION
SELECT 'maximum PGA allocated' AS name, TO_CHAR(value) AS value
FROM   v$pgastat
WHERE  name = 'maximum PGA allocated';

