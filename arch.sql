col name for a50 heading archive_name
col IS_RECOVERY_DEST_FILE heading IN_FRA for a6
col STATUS for a6
select * 
from (
select FIRST_CHANGE#,NEXT_CHANGE#,sequence#,thread#,dest_id,recid, STATUS,IS_RECOVERY_DEST_FILE,COMPRESSED,name
from v$archived_log
order by FIRST_CHANGE# desc) a
where rownum <= 5;
