set lines 180
col inst_id for 999999
col protection_mode for a20    
col protection_level for a20
col remote_archive for a10
col database_role for a15
col dataguard_broker for a15               
col guard_status for a10 heading GUARD
col switchover_status for a15 heading CONV_TO
select INST_ID,protection_mode,
--protection_level,
remote_archive,database_role,
       dataguard_broker,guard_status,switchover_status
from gv$database
order by 1;


col first_time for a20;
col FIRST_CHANGE# for 9999999999999999999;

select THREAD#,FIRST_CHANGE#,FIRST_TIME,SEQUENCE#,DEST_ID,APPLIED
from gv$archived_log
where sequence# = (select max(sequence#)
from gv$archived_log
where applied= 'YES')
order by THREAD#,FIRST_CHANGE#,DEST_ID;


