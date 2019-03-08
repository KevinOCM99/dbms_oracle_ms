COLUMN plan FORMAT A30
COLUMN pluggable_database FORMAT A25
SET LINESIZE 100 VERIFY OFF

SELECT plan, 
       pluggable_database, 
       shares, 
       utilization_limit AS util,
       parallel_server_limit AS parallel
FROM   dba_cdb_rsrc_plan_directives
WHERE  plan like UPPER('&plan')||'%'
ORDER BY plan, pluggable_database;

