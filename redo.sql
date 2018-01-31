select group#,sequence#,members,status,ARCHIVED, FIRST_CHANGE#, NEXT_CHANGE# 
from v$log
order by group#;

col IS_RECOVERY_DEST_FILE heading IN_FRA for a6
col member for a59
select GROUP#,type,IS_RECOVERY_DEST_FILE ,status, member
from v$logfile order by group#;

