select current_scn from v$database;

select df.name,df.checkpoint_change# SCN_IN_CTRLFILE,dfh.checkpoint_change# SCN_OF_HEADER,df.LAST_CHANGE# LAST_SCN
from v$datafile df, v$datafile_header dfh
where df.FILE# = dfh.FILE#
order by df.FILE#;

select file#,change# from v$recover_file;

SELECT NAME, SCN, TIME, DATABASE_INCARNATION#,GUARANTEE_FLASHBACK_DATABASE,STORAGE_SIZE
FROM V$RESTORE_POINT;

