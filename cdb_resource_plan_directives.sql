COLUMN plan FORMAT A30
COLUMN pluggable_database FORMAT A25
SET LINESIZE 100

SELECT plan, 
       pluggable_database, 
       shares, 
       utilization_limit AS util,
       parallel_server_limit AS parallel
FROM   dba_cdb_rsrc_plan_directives
WHERE  plan = '&1'
ORDER BY pluggable_database;

undefine 1