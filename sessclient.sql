set lines 180;
col username for a10;
col client_version for a15;
col osuser for a10;
col machine for a15;
col module for a20;
col program for a15;
col client_charset for a10;
col client_driver for a10;
col client_conn for a20;
col service_name for a15;
col server for a1;
SELECT 
/* a.sid, a.serial#, */ b.username, 
a.client_version, a.osuser, 
b.machine, b.module, b.program, 
a.client_charset , a.client_driver, 
substr(a.client_connection, 0, 4) client_conn, 
b.service_name, 
substr(b.server,0,1) server 
FROM gv$session_connect_info a, gv$session b 
WHERE a.sid = b.sid 
and a.serial# = b.serial# 
and b.module <> 'DBMS_SCHEDULER' 
and network_service_banner like 'TCP%' 
ORDER BY client_version, username; 
