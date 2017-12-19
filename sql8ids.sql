---------------------------------------------------------------------------------
-- KnownFirst : SQL_ID                                                         --
-- ScriptName : sql8ids.sql (SQL_ID->SQL_Full_Text) [V2]                       --
-- IntendedTo : Get SQL Status for a specific sql                              --
-- DDictionay : GV$SQLAREA|DBA_HIST_SQLTEXT                                    --
-- Applicable : 11g                                                            --
-- CreationOn : 20140730                                                       --
-- RevisionOn : 20140731                                                       --
---------------------------------------------------------------------------------
ttitle off
clear columns breaks computes
accept sql_id prompt "Your SQL_ID? "

-------------
-- COLUMNS --
-------------
column version_count    format 99999999 heading "Versions"
column sql_text         format a64 heading "SQL_TEXT" truncated
column last_load_time   format a019 heading "LAST_LOAD_TIME"
column last_active_time format a019 heading "LAST_ACTIVE_TIME"
column flag             format a001 heading "F"
column sql_id		noprint
column executions	format 9999999999 heading Executions
       
with mem as (
select 
       'M'                                               as flag
     , to_char(last_load_time  ,'yyyy-mm-dd_hh24:mi:ss') as last_load_time
     , to_char(last_active_time,'yyyy-mm-dd_hh24:mi:ss') as last_active_time
     , version_count
     , sql_id
     , executions
  from gv$sqlarea a
  where a.sql_id='&sql_id'
), his as (
select 'H'                              as flag
     , null
     , null
     , version_count
     , sql_id
     , executions_delta as executions
  from dba_hist_sqlstat b
 where b.sql_id='&sql_id'
 and b.dbid=(select dbid from v$database)
), his2 as (
select t.flag
     , to_char(max(s.SQL_EXEC_START),'yyyy-mm-dd_hh24:mi:ss') as last_load_time
     , to_char(max(s.SAMPLE_TIME   ),'yyyy-mm-dd_hh24:mi:ss') as last_active_time     
     , sum(t.version_count) version_count
     , t.sql_id
     , sum(executions) executions
  from his t
  left outer
  join DBA_HIST_ACTIVE_SESS_HISTORY s
    on t.sql_id=s.sql_id
 group by t.sql_id,t.flag
)
select * from his2
 union all
select * from mem
 order by 1,2,3
/
