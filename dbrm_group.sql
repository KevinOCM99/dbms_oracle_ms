COLUMN status FORMAT A10
COLUMN comments FORMAT A70
col consumer_group for a30
SELECT consumer_group,
       status,
       comments
FROM   dba_rsrc_consumer_groups
ORDER BY consumer_group;

