select current_scn from v$database;

select df.name,df.checkpoint_change# SCN_IN_CTRLFILE,dfh.checkpoint_change# SCN_OF_HEADER,df.LAST_CHANGE# LAST_SCN
from v$datafile df, v$datafile_header dfh
where df.FILE# = dfh.FILE#
order by df.FILE#;

select file#,change# from v$recover_file;

select current_scn,dbms_flashback.get_system_change_number from v$database;

