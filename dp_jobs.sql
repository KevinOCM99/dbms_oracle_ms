col job_name for a30
col operation for a20
col JOB_MODE for a10
col state for a20
select job_name, operation, state, JOB_MODE from dba_datapump_jobs;

