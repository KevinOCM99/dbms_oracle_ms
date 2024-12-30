
set lines 180 pages 999;
alter session set NLS_LANGUAGE='ENGLISH';
alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD"T"HH24:MI:SS.FF';
alter session set NLS_TIMESTAMP_TZ_FORMAT='YYYY-MM-DD"T"HH24:MI:SS.FF TZR';


col JOB_START_TIME for a36;
col window_start_time for a36;
col window_end_time for a36;
col window_duration for a26;
col JOB_DURATION for a20;
col WINDOW_NAME for a20;
col job_status for a15;
col job_name for a6;



select  case client_name when 'auto optimizer stats collection' then 'STATS' when 'auto space advisor' then 'SPACE' when 'sql tuning advisor' then 'TUNING' end job_namewindow_start_time,jobs_completed,window_duration,window_end_time
from DBA_AUTOTASK_CLIENT_HISTORY
where trunc(window_start_time) >= sysdate-8 
--and client_name='auto optimizer stats collection'
order by 1,2 desc;

select case client_name when 'auto optimizer stats collection' then 'STATS' when 'auto space advisor' then 'STATS' when 'sql tuning advisor' then 'STATS' end job_name, job_start_time,job_status,window_name,window_start_time,window_duration,job_duration
from DBA_AUTOTASK_JOB_HISTORY
where trunc(job_start_time) >= sysdate-8 
--and client_name='auto optimizer stats collection'
order by 1,2 desc;
