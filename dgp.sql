set lines 120 pages 999
col PID for 99999 
col process for a10
col client_pid for a10
col status for a15
SELECT inst_id, PROCESS, PID, STATUS, THREAD#, CLIENT_PID, SEQUENCE#, BLOCK#, BLOCKS
FROM GV$MANAGED_STANDBY
ORDER BY 1,2,3;
