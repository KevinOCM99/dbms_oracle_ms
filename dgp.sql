col inst_id for 999 heading INS
col PID for a7
col process for a5
col client_pid for a7 heading C_PID
col status for a9
col thread# for 999999 heading THRD#
col SEQUENCE# for 99999 heading SEQ#
SELECT inst_id, PROCESS, PID, STATUS, THREAD#, CLIENT_PID, SEQUENCE#, BLOCK#, BLOCKS
FROM GV$MANAGED_STANDBY
ORDER BY 1,2,3;
