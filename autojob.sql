set lines 180 pages 999;

@nls4mt

col client_name for a40
col task_name for a29
col operation_name for a40
SELECT CLIENT_NAME,TASK_NAME,OPERATION_NAME,STATUS FROM dba_autotask_task order by 1;


col client_name for a31;
col status for a10;
select client_name,status from dba_autotask_client order by 1;



col COMMENTS for a100
col program_type for a20
col PROGRAM_NAME for a23;
SELECT PROGRAM_NAME,PROGRAM_TYPE,ENABLED,COMMENTS FROM dba_scheduler_programs  WHERE PROGRAM_NAME in('GATHER_STATS_PROG','AUTO_SPACE_ADVISOR_PROG','AUTO_SQL_TUNING_PROG')
order by 1;


col window_name for a18;
col REPEAT_INTERVAL for a35 ;
col duration for a14;
col open for a5;
col LAST_START_DATE for a34;
col NEXT_START_DATE for a34;
SELECT a.WINDOW_NAME,a.duration,ENABLED OPEN,LAST_START_DATE,NEXT_START_DATE ,a.REPEAT_INTERVAL FROM dba_scheduler_windows a order by next_start_date;


col window_name for a18;
col window_next_time for a34;
col autotask_status for a15;
col window_active for a15;
col optimizer_stats for a15;
col segment_advisor for a15;
col sql_tune_advisor for a15;
SELECT window_name, window_next_time, window_active, autotask_status, optimizer_stats, segment_advisor, sql_tune_advisor
FROM dba_autotask_window_clients
order by window_next_time;
