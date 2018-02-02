select current_scn from v$database;

col HEADER_UPDATED_AT for a19 heading HEADER_UPDATED_TIME
select df.name,df.checkpoint_change# SCN_IN_CTRLFILE,dfh.checkpoint_change# SCN_OF_HEADER,to_char(SCN_TO_TIMESTAMP(dfh.checkpoint_change#),'YYYY-MM-DD HH24:MI:SS') HEADER_UPDATED_AT,df.LAST_CHANGE# LAST_SCN
from v$datafile df, v$datafile_header dfh
where df.FILE# = dfh.FILE#
order by df.FILE#;

select file#,change# from v$recover_file;

SELECT NAME, SCN, TIME, DATABASE_INCARNATION#,GUARANTEE_FLASHBACK_DATABASE,STORAGE_SIZE
FROM V$RESTORE_POINT;

