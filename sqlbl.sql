col sql_handle for a30;
col plan_name for a40;
col enabled for a7;
col accepted for a8;
col FIXED for a5;
col LAST_VERIFIED for a20;
SELECT sql_handle, plan_name, enabled, accepted, FIXED, to_char(LAST_VERIFIED,'yyyy-mm-dd hh24:mi:ss') LAST_VERIFIED
FROM   dba_sql_plan_baselines
WHERE  sql_text LIKE '%spm_test_tab%'
AND    sql_text NOT LIKE '%dba_sql_plan_baselines%';
