set lines 180
col inst_id for 999999
col protection_mode for a20    
col protection_level for a20
col remote_archive for a10
col database_role for a29
col dataguard_broker for a11 heading DG_BROKER 
col guard_status for a10 heading GUARD
col switchover_status for a17 heading CONV_TO
select INST_ID,protection_mode,
--protection_level,
remote_archive,database_role || '(' || (select case value when 'TRUE' then 'Cluster-DB' else 'Non-Cluster' end  from v$option where parameter = 'Real Application Clusters') || ')' database_role,
       dataguard_broker,guard_status,switchover_status
from gv$database
order by 1;


col first_time for a20;
col FIRST_CHANGE# for 9999999999999999999;

select distinct THREAD#,FIRST_CHANGE#,FIRST_TIME,SEQUENCE#,DEST_ID,APPLIED
from gv$archived_log
where to_char(THREAD#) || 'kk' || to_char(SEQUENCE#) || 'kk' || to_char(resetlogs_change#) in
(select to_char(THREAD#) || 'kk' || to_char(max(SEQUENCE#)) || 'kk' || to_char(max(resetlogs_change#))
 from (select THREAD#,SEQUENCE#,resetlogs_change# from gv$archived_log
 where applied= 'YES' and resetlogs_change#=(select max(resetlogs_change#) from v$archived_log))
 group by THREAD#
) 
and applied= 'YES' 
order by THREAD#,FIRST_CHANGE#,DEST_ID;

