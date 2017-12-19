--------------------------------------------
-- Query Usage : @fra                     --
-- Purpose     : FRA Situation            --
-- Update Date : 20131220-20140107        --
-- Test On     : 11.2.0.3.0               --
--------------------------------------------
prompt *************************
prompt * Query on GV$PARAMETER *
prompt *************************
ttitle off

column db_name         format a10
column inst_name       format a10
column inst_id         format 9
column host_name       format a9
column num             format 9999
column parameter_name  format a30
column parameter_type  format a15
column parameter_value format a30
column display_value   format a20 truncated
column ses             format a3
column sys             format a3
column ins             format a3
column def             format a3
column mod             format a3
column adj             format a3
column dep             format a3
column bas             format a3
break on db_name on inst_name
select d.name                                                                          as db_name
     , i.instance_name                                                                 as inst_name
     , p.name                                                                          as parameter_name
     , p.value                                                                         as parameter_value
     , decode(p.name,'db_flashback_retention_target',round(p.display_value/60,2)||' hours',p.display_value) as display_value
  from gv$parameter p
     , gv$instance  i
     , gv$database  d
 where p.inst_id=i.inst_id
   and p.inst_id=d.inst_id
   and p.name in ('db_recovery_file_dest','db_recovery_file_dest_size','db_flashback_retention_target')
 order by d.name,i.instance_name,p.name
/
prompt
prompt *********************************
prompt * Query on V$RECOVERY_FILE_DEST *
prompt *********************************
ttitle off
--clear columns breaks computes
column name                 heading "DB FRA|Destination"    format a15
column space_limit_mb       heading "Quota|Space(MB)"       format 999999999
column timestamp            heading "Check|Timestamp"       format a19
column space_used_mb        heading "Used|Space(MB)"        format 999999999
column space_reclaimable_mb heading "Reclaimable|Space(MB)" format 999999999
column space_available      heading "Available|Space(MB)"   format 999999999
column usage_percent        heading "Usage|Percent"         format a07
column number_of_files      heading "File|Count"            format 999999
select name
     , round(space_limit/1048576)                                as space_limit_mb
     , to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')                  as timestamp
     , round(space_used/1048576)                                 as space_used_mb
     , round(space_reclaimable/1048576)                          as space_reclaimable_mb
     , round((space_limit-space_used+space_reclaimable)/1048576) as space_available
     , lpad(ltrim(to_char(round((space_used-space_reclaimable)/space_limit*100,4),'FM999.90'))||'%',7,' ') as usage_percent
     , number_of_files
  from v$recovery_file_dest
/
prompt
prompt ****************************************
prompt * Query on V$FLASH_RECOVERY_AREA_USAGE *
prompt ****************************************
column file_type                 format a20    heading "File|Type"
column number_of_files           format 999999 heading "File|Count"
column mb_space_used             format 999999 heading "Occupied|Size(MB)"
column percent_space_used        format 999.00 heading "Occupied|Percent(%)"
column percent_space_reclaimable format 999.00 heading "Reclaimable|Percent(%)"
column mb_space_reclaimable      format 999999 heading "Reclaimable|Size(MB)"
select u.file_type
     , u.number_of_files
     , round(p.value*u.percent_space_used/100/1024/1024)        as mb_space_used
     , u.percent_space_used
     , round(p.value*u.percent_space_reclaimable/100/1024/1024) as mb_space_reclaimable
     , u.percent_space_reclaimable
  from v$flash_recovery_area_usage u
     , v$parameter                 p
 where u.number_of_files>0
   and p.name='db_recovery_file_dest_size'
 order by u.file_type --number_of_files desc
/
prompt
prompt ****************************************
prompt * Query on V$FLASHBACK_DATABASE_LOG *
prompt ****************************************
col curent_time for a20
col current_scn for 999999999999999
col back_2_time for a20
col back_2_scn for 999999999999999
select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') curent_time
,timestamp_to_scn(sysdate) current_scn
,to_char(oldest_flashback_time,'yyyy-mm-dd hh24:mi:ss') back_2_time 
,oldest_flashback_scn back_2_scn
from v$flashback_database_log
/

prompt
prompt ****************************************
prompt * Query on V$RESTORE_POINT *
prompt ****************************************
col RP_NAME for a30;
col scn for 9999999999999999;
col GUARANTEE_FLASHBACK_DATABASE for a9 heading GUARANTEE;
col STORAGE_SIZE for 99999999999999;
col time for a32;

SELECT NAME RP_NAME, SCN, TIME, GUARANTEE_FLASHBACK_DATABASE,STORAGE_SIZE
FROM V$RESTORE_POINT;