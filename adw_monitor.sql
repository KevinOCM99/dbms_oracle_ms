--elapsed time not work
--no io

select status, username,to_char(sql_exec_start,'yyyy-mm-dd hh24:mi:ss') start_time, sql_id,rm_consumer_group,px_maxdop,elapsed_time, (elapsed_time + queuing_time + cpu_time)
from V$SQL_MONITOR 
where username is not null and username <> 'C##CLOUD$SERVICE' 
order by username,sql_exec_start desc;

