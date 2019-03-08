col name for a30
col consumed_cpu_time for 99999
SELECT name,
       consumed_cpu_time
FROM   v$rsrc_consumer_group
ORDER BY name;

