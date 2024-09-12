set lines 180
col db_name format a15
col INS_NAME format a15
col INS_STAT for a8
col host_name format a27
col user_name format a15
col FORCE_LOGGING format a13
col LOGINS for a12;
col FLASHBACK for a9;
SELECT 
    i.host_name,
    i.INSTANCE_NAME INS_NAME,
    i.STATUS AS INS_STAT,
    d.NAME AS DB_NAME,
    d.DATABASE_ROLE,
    d.OPEN_MODE,
    d.LOG_MODE AS ARCHIVELOG, 
    d.FORCE_LOGGING,               
    i.LOGINS,                      
    d.FLASHBACK_ON FLASHBACK                 
FROM 
    GV$INSTANCE i
JOIN 
    GV$DATABASE d 
ON 
    i.INST_ID = d.INST_ID
ORDER BY 
    i.INSTANCE_ID;

@uptime
