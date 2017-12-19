col sid for 999
col serial# for 99999
col spid for a5
col machine for a15
col program for a15
col osuer for a15
col status for a10
col username for a10
col logon for a10

undefine sid
accept sid number prompt 'please input session id: '


SELECT DECODE(TRUNC(SYSDATE - LOGON_TIME), 0, NULL, TRUNC(SYSDATE - LOGON_TIME) || ' Days' || ' + ') || 
TO_CHAR(TO_DATE(TRUNC(MOD(SYSDATE-LOGON_TIME,1) * 86400), 'SSSSS'), 'HH24:MI:SS') LOGON, 
SID, v$session.SERIAL#, v$process.SPID , ROUND(v$process.pga_used_mem/(1024*1024), 2) PGA_MB_USED, 
v$session.USERNAME, STATUS, OSUSER, MACHINE, v$session.PROGRAM
--, MODULE 
FROM v$session, v$process 
WHERE v$session.paddr = v$process.addr 
--and status = 'ACTIVE' 
and v$session.sid = '&&sid'
--and v$session.username = 'SYSTEM' 
--and v$process.spid = 24301
ORDER BY pga_used_mem DESC;

col value for 99999999999999999999999
select name, value
from v$statname n, v$sesstat t
where n.statistic# = t.statistic#
and t.sid = &&sid
and n.name in ( 'session pga memory', 'session pga memory max', 'session uga memory', 'session uga memory max');

