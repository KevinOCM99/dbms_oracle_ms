set lines 180 pages 999
col inst_id for 99
col group# for 99
col status for a15
col member for a100
col type for a15
SELECT INST_ID, GROUP#,TYPE, STATUS, MEMBER FROM GV$LOGFILE order by 1,2;
