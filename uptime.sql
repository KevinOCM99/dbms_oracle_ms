set lines 180 pages 999
col Instance_Name for a13 heading Instance_Name
col Started_At for a20
col "Database_Uptime" for a40
col current_scn for 999999999999999
col SESSIONTIMEZONE for a10
col DBTIMEZONE for a10
col SESSIONTIMEZONE for a10 heading MYTIMEZONE
select INST_ID,instance_name,
to_char(startup_time,'YYYY-MM-DD HH24:MI:SS') as "Started_At",
floor(sysdate - startup_time) || 'days(s) '|| trunc( 24*((sysdate-startup_time) - trunc(sysdate-startup_time))) || 'hour(s) '|| mod(trunc(1440*((sysdate-startup_time) - trunc(sysdate-startup_time))), 60) ||'minute(s) '|| mod(trunc(86400*((sysdate-startup_time) - trunc(sysdate-startup_time))), 60) ||'seconds'as "Database_Uptime"
,timestamp_to_scn(sysdate) current_scn,
to_char(CURRENT_DATE,'yyyy-mm-dd hh24:mi:ss') Current_date, DBTIMEZONE, SESSIONTIMEZONE
FROM gv$instance
order by INST_ID;
