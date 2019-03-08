COLUMN plan for a30
COLUMN status FORMAT A10
COLUMN comments FORMAT A50
SELECT plan,
       status,
       comments
FROM   dba_rsrc_plans
ORDER BY plan;
