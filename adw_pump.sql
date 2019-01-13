col owner_name for a20
col job_name for a30
col operation for a10
col job_mode for a10
col state for a15
col degree for 99999 for 99 heading PX
col datapump_sessions for 9999 heading SESS
select owner_name,job_name,operation,job_mode,state,degree,datapump_sessions
from dba_datapump_jobs
order by job_name desc;
