set lines 120
COLUMN component FORMAT A30
col version for 99

show parameter memory;
show parameter sga;
show parameter pga;

col current_size for 99999999999999
col MIN_SIZE for 99999999999999
col max_size for 99999999999999

SELECT  component, current_size, min_size, max_size
FROM    v$memory_dynamic_components
WHERE   current_size != 0
order by 1;

SELECT SUM(pga_used_mem) PGA_USED FROM v$process;

SELECT * 
FROM v$memory_target_advice 
ORDER BY memory_size;
