--elapsed time not work
--no io

col username for a20;
col RM_CONSUMER_GROUP for a20 heading CONSUMER_GROUP;
col status for a30;
select SQL_ID,SQL_EXEC_ID,to_char(sql_exec_start,'yyyy-mm-dd hh24:mi:ss') start_time,status, username, rm_consumer_group,px_maxdop,elapsed_time, (elapsed_time + queuing_time + cpu_time) all_time_sum
from V$SQL_MONITOR 
where username is not null and username <> 'C##CLOUD$SERVICE' 
order by username,sql_exec_start desc;

