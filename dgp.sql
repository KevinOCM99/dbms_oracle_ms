set lines 120;
col PID for a8
col process for a10
col client_pid for a10
col status for a15
SELECT PROCESS, PID, STATUS, THREAD#, CLIENT_PID, SEQUENCE#, BLOCK#, BLOCKS
FROM V$MANAGED_STANDBY
ORDER BY 1,2;
