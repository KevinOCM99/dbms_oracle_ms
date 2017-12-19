----------------------------------------------------------------------------------------------------
-- Script Type : Function [ Standalone ]                                                          --
-- Script Name : sql_plan_change.sql                                                              --
-- Parameter   : one : SQL_ID                                                                     --
-- Birthday    : 2015-04-02                                                                       --
-- Revision    : 2015-04-12                                                                       --
-- Change #1   :                                                                                  --
----------------------------------------------------------------------------------------------------

--------------------
-- INITIALIZATION --
--------------------
ttitle off
set linesize 200 pagesize 999
undefine sql_id
clear columns breaks computes

-----------
-- TITLE --
-----------
prompt ......................................................  .........................
prompt > DBA_HIST_SQLSTAT LEFT OUTER JOIN DBA_HIST_SNAPSHOT <  > REVISION : 2015-04-12 <
prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^

-------------
-- COLUMNS --
-------------
column execs               format 999,999
column avg_etime           format 999,999.999
column avg_lio             format 999,999,999
column begin_interval_time format a30
column plan_hash_value2    format a17         heading "PLAN_HASH_VALUE" justify right
column node                format 99999
break on plan_hash_value on plan_hash_value2

----------
-- BODY --
----------
select ss.snap_id
     , ss.instance_number node
     , to_char(ss.begin_interval_time,'yyyy-mm-dd:hh24:mi:ss') as begin_interval_time
     , st.sql_id
     , hv.plan_hash_value2
     , nvl(st.executions_delta,0) execs
     , (st.elapsed_time_delta/decode(nvl(st.executions_delta,0),0,1,st.executions_delta))/1000000 avg_etime
     , round(st.buffer_gets_delta/decode(nvl(st.buffer_gets_delta,0),0,1,st.executions_delta)) avg_lio
  from dba_hist_sqlstat st
  left outer
  join dba_hist_snapshot ss
    on st.dbid=ss.dbid
       /* There may be more than one DBID in AWR: select distinct dbid from dba_hist_snapshot; */
   and st.instance_number=ss.instance_number
   and st.snap_id=ss.snap_id
  left outer
  join (select plan_hash_value
             , lpad('#'||rank()over(order by min_snap_id),4,' ')||':'||lpad(plan_hash_value,12,' ') as plan_hash_value2
          from (select plan_hash_value
                     , min(snap_id) as min_snap_id
                  from dba_hist_sqlstat
                 where 1=1
                   and sql_id = nvl('&sql_id','x')
                 group by sql_id, plan_hash_value
                 order by min_snap_id
               )
       ) hv
    on st.plan_hash_value=hv.plan_hash_value
 where 1=1
   and st.sql_id = nvl('&sql_id','x')
   and st.executions_delta > 0
 order by 1, 2, 3
/

--------
-- HK --
--------
undefine sql_id
clear columns breaks computes
---------
-- EOF --
---------
