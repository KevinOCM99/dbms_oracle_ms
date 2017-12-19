col Instance_Name for a20 heading Instance_Name
col Started_At for a20
col "Database_Uptime" for a40
col current_scn for 999999999999999
select instance_name,
to_char(startup_time,'DD-MON-YYYY HH24:MI:SS') as "Started_At",
timestamp_to_scn(sysdate) current_scn,
floor(sysdate - startup_time) || 'days(s) '|| trunc( 24*((sysdate-startup_time) - trunc(sysdate-startup_time))) || 'hour(s) '|| mod(trunc(1440*((sysdate-startup_time) - trunc(sysdate-startup_time))), 60) ||'minute(s) '|| mod(trunc(86400*((sysdate-startup_time) - trunc(sysdate-startup_time))), 60) ||'seconds'as "Database_Uptime"
FROM v$instance;
