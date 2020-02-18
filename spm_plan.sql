set lines 180 pages 999;
col sql_handle for a30;
col plan_name for a35;
col creator for a10;
col CREATED for a28;
col signature for 999999999999999999999999;
break on signature;
SELECT signature,plan_name,
--sql_handle,
enabled, accepted,fixed, reproduced, adaptive, origin,CREATOR,CREATED FROM
dba_sql_plan_baselines
order by 1;
