col log_owner for a15;
col master for a40;
col log_table for a40;
SELECT log_owner, master, log_table
FROM dba_mview_logs
where log_owner like upper('&owner%')
and master like upper('&mv%')
order by 1,2;