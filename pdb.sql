set lines 180
col name for a20;
col open_mode for a20;
col con_id for 999;
col create_scn for 9999999999999999;
col total_size_MB for 999999;
select con_id, name, open_mode,create_scn,total_size/1024/1024 total_size_MB,guid
from v$pdbs;