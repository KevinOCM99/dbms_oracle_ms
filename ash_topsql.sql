set echo off
----------------------------------------------------------------------------------------------------
-- Script       : ash_topsql.sql                                                                  --
-- Category     : Standalone Function                                                             --
-- Description. :                                                                                 --
-- Birthday     : 2015-04-07                                                                      --
-- Dictionary   : GV$ACTIVE_SESSION_HISTORY                                                       --
-- Notes....... : To run this script the Diagnostic Pack license is required.                     --
-- Parameter #1 : &sid -- Session ID                                                              --
-- Parameter #2 : &t   -- Time range                                                              --
-- Usage Sample :                                                                                 --
--    Sample A - sysdate-1/24 and sysdate /* today => "TRUNC(sysdate) sysdate" */                 --
--    Sample B - "TIMESTAMP'2015-03-29 13:00:00'" and "TIMESTAMP'2015-03-29 13:15:00'"            --
----------------------------------------------------------------------------------------------------

---------
-- SET --
---------
set linesize 200 pagesize 40
set echo off termout on scan on verify off feedback off

------------
-- DEFINE --
------------
undefine sid
undefine t

accept sid prompt "Session ID : "
accept t   prompt "Time Range : "

set echo off termout off
set newpage none heading off feedback off
column b newline
spool p.sql
select decode('&t','','prompt Warning: No DEFINE found for Time Range!'  ,null) as a
     , decode('&t','','pause  Press <Ctrl>+<C> to quit current execution',null) as b
from dual;
spool off
set termout on
@@p
set newpage 1 heading on feedback off

---------
-- COL --
---------
column rank_id      format 99           heading "Rank"
column activity_pct format a09          heading "Activity%"
column db_time      format 9,999,999    heading "DB Time"
column cpu_pct      format a06          heading "CPU%"       justify right
column user_io_pct  format a06          heading "UsrIO%"     justify right
column wait_pct     format a06          heading "Wait%"      justify right
column sql_id       format a13          heading "SQL_ID"
column sql_opname   format a15          heading "Command"
column sql_plan_cnt format 999999       heading "Plans"
column sql_exec_cnt format 999999       heading "Execs"
column awr_captured format 999999       heading "AWR_Captured"
----------
-- BODY --
----------
select rank()over(order by activity_pct desc)                                as rank_id
     , sql_id                                                                as sql_id
     , sql_opname                                                            as sql_opname
     , sql_plan_cnt                                                          as sql_plan_cnt
     , sql_exec_cnt                                                          as sql_exec_cnt
     , awr_captured                                                          as awr_captured
     , lpad(to_char(activity_pct,'fm999.0')||'%',9,' ')                      as activity_pct
     , db_time                                                               as db_time
     , lpad(to_char(round(cpu_time    /db_time*100,1),'fm999.0')||'%',6,' ') as cpu_pct
     , lpad(to_char(round(user_io_time/db_time*100,1),'fm999.0')||'%',6,' ') as user_io_pct
     , lpad(to_char(round(wait_time   /db_time*100,1),'fm999.0')||'%',6,' ') as wait_pct
  from (
select sql_id                                                                   as sql_id
     , sql_opname                                                               as sql_opname
     , round(100 * ratio_to_report(sum(1)) over (), 1)                          as activity_pct
     , sum(1)                                                                   as db_time
     , sum(decode(session_state,'ON CPU' ,1,0))                                 as cpu_time
     , sum(decode(session_state,'WAITING',decode(wait_class,'User I/O',1,0),0)) as user_io_time
     , sum(decode(session_state,'WAITING',1,0))-
       sum(decode(session_state,'WAITING',decode(wait_class,'User I/O',1,0),0)) as wait_time
     , count(distinct sql_plan_hash_value)                                      as sql_plan_cnt
     , count(distinct sql_exec_id)                                              as sql_exec_cnt
     , sum(decode(is_awr_sample,'Y',1,0))                                       as awr_captured
  from gv$active_session_history
 where 1=1
 --and sample_time >  to_timestamp(t1,'YYYY-MM-DD_HH24:MI:SSXFF')
 --and sample_time <= to_timestamp(t2,'YYYY-MM-DD_HH24:MI:SSXFF')
   and sample_time between &t
   and sql_id is not null /* suppress interference of background processes */
   and session_id = decode(lower('&sid'),'all',session_id,null,session_id,to_number('&sid'))
 group by sql_id, sql_opname
 order by sum(1) desc
)
where rownum <= 10
;

prompt
--------
-- HK --
--------
clear columns breaks computes
set feedback on echo off termout on newpage 1
undefine sid
undefine t

---------
-- EOF --
---------
