--V$SYS_TIME_MODEL                 | V$SESS_TIME_MODEL
-- Name       Null?  Type          | Name       Null?  Type
-- ---------- ------ ------------- | ---------- ------ -------------
--                                 | SID               NUMBER
-- STAT_ID           NUMBER        | STAT_ID           NUMBER
-- STAT_NAME         VARCHAR2(64)  | STAT_NAME         VARCHAR2(64)
-- VALUE             NUMBER        | VALUE             NUMBER

ttitle off
clear columns breaks computes
set linesize 200 pagesize 40 heading on
set feedback off

-- Keep the following in mind regarding the tree:
-- Children do not necessarily add up to the parent.
-- Children are not necessarily exclusive (that is, they may overlap).
-- The union of children does not necessarily cover the whole of the parent.

prompt ..................................................
prompt > RELATIONSHIP TREES OF SESSION-LEVEL TIME MODEL <
prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

column sid         format 99999            heading "SID"
column value_sec   format 999999999        heading "Time(Sec)"
column stat_name   format a69              heading "Statistical Operation"
column value_micro format 999999999,999999 heading "Time(Micro)"
column stat_desc   format a92              heading "Description"

with t as (
select sid
     , decode(stat_name,'background elapsed time'                 ,'Background'
                       ,'background cpu time'                     ,'Background'
                       ,'RMAN cpu time (backup/restore)'          ,'Background'
                       ,'Foreground') as type
     , decode(stat_name,'background elapsed time'                         , 1
                       ,'background cpu time'                             , 2
                       ,'RMAN cpu time (backup/restore)'                  , 3
                       ,'DB time'                                         , 4
                       ,'DB CPU'                                          , 5
                       ,'connection management call elapsed time'         , 6
                       ,'sql execute elapsed time'                        , 7
                       ,'parse time elapsed'                              , 8
                       ,'hard parse elapsed time'                         , 9
                       ,'hard parse (sharing criteria) elapsed time'      ,10
                       ,'hard parse (bind mismatch) elapsed time'         ,11
                       ,'failed parse elapsed time'                       ,12
                       ,'failed parse (out of shared memory) elapsed time',13
                       ,'repeated bind elapsed time'                      ,14
                       ,'sequence load elapsed time'                      ,15
                       ,'PL/SQL execution elapsed time'                   ,16
                       ,'inbound PL/SQL rpc elapsed time'                 ,17
                       ,'PL/SQL compilation elapsed time'                 ,18
                       ,'Java execution elapsed time'                     ,19
                       ,'OLAP engine elapsed time'                        ,20
                       ,'OLAP engine CPU time'                            ,21
                       ,99) as id
     , decode(stat_name,'background elapsed time'                         , null
                       ,'background cpu time'                             , 1
                       ,'RMAN cpu time (backup/restore)'                  , 2
                       ,'DB time'                                         , null
                       ,'DB CPU'                                          , 4
                       ,'connection management call elapsed time'         , 4
                       ,'sql execute elapsed time'                        , 4
                       ,'parse time elapsed'                              , 4
                       ,'hard parse elapsed time'                         , 8
                       ,'hard parse (sharing criteria) elapsed time'      , 9
                       ,'hard parse (bind mismatch) elapsed time'         ,10
                       ,'failed parse elapsed time'                       , 8
                       ,'failed parse (out of shared memory) elapsed time',12
                       ,'repeated bind elapsed time'                      , 4
                       ,'sequence load elapsed time'                      , 4
                       ,'PL/SQL execution elapsed time'                   , 4
                       ,'inbound PL/SQL rpc elapsed time'                 , 4
                       ,'PL/SQL compilation elapsed time'                 , 4
                       ,'Java execution elapsed time'                     , 4
                       ,'OLAP engine elapsed time'                        , 4
                       ,'OLAP engine CPU time'                            ,20
                       ,null) as pid
     , stat_name
     , decode(stat_name,'background elapsed time'                         ,'Background processes'
                       ,'background cpu time'                             ,'Background processes'
                       ,'RMAN cpu time (backup/restore)'                  ,'RMAN backup and restore operations'
                       ,'DB time'                                         ,'Performing user-level calls, NOT instance background processes'
                       ,'DB CPU'                                          ,'Performing user-level calls, NOT instance background processes'
                       ,'connection management call elapsed time'         ,'Performing session connect and disconnect calls'
                       ,'sql execute elapsed time'                        ,'Note that, for select statements, performing fetches of query results'
                       ,'parse time elapsed'                              ,'Parsing SQL statements, includes both soft and hard parse time'
                       ,'hard parse elapsed time'                         ,'Hard parsing SQL statements'
                       ,'hard parse (sharing criteria) elapsed time'      ,'Hard parse resulted from not being able to share an existing cursor in the SQL cache'
                       ,'hard parse (bind mismatch) elapsed time'         ,'Hard parse resulted from bind type or bind size mismatch with existing cursor in SQL cache'
                       ,'failed parse elapsed time'                       ,'Performing SQL parses which ultimately fail with some parse error'
                       ,'failed parse (out of shared memory) elapsed time','Performing SQL parses which ultimately fail with error ORA-04031'
                       ,'repeated bind elapsed time'                      ,'Giving new values to bind variables (rebinding)'
                       ,'sequence load elapsed time'                      ,'Getting next sequence number from the data dictionary'
                       ,'PL/SQL execution elapsed time'                   ,'Running PL/SQL interpreter, NOT recursively executing SQL or Java VM'
                       ,'inbound PL/SQL rpc elapsed time'                 ,'Recursively executing SQL and JAVA'
                       ,'PL/SQL compilation elapsed time'                 ,'Running PL/SQL compiler'
                       ,'Java execution elapsed time'                     ,'Running Java VM, NOT recursively executing SQL or PL/SQL'
                       ,'OLAP engine elapsed time'                        ,'OLAP session transactions'
                       ,'OLAP engine CPU time'                            ,'OLAP session transactions'
                       ,null) as stat_desc
     , value
  from v$sess_time_model
 where 1=1
   and sid  = &sid
   and decode(stat_name,'background elapsed time'                 ,'Background'
                       ,'background cpu time'                     ,'Background'
                       ,'RMAN cpu time (backup/restore)'          ,'Background'
                       ,'Foreground')='Foreground'
),   m as (
select t1.id
     , t1.pid
     , t1.sid
     , NVL2(t2.value,'('||lpad(to_char(round(t1.value/nullif(t2.value,0)*100),'FM90.00'),5,' ')||'%) ',null)||t1.stat_name as stat_name
     , t1.value
     , t1.stat_desc
  from t t1
  left outer join t t2
    on t1.pid=t2.id
 where 1=1
)
select sid
     , value                                   as value_micro
     , round(value/1e6)                        as value_sec
     , lpad(' `- ',(level-1)*4,' ')||stat_name as stat_name
   --, stat_desc
  from m
 where 1=1
 start with pid is null
connect by nocycle prior id = pid
 order siblings by id
;

set feedback off

-- Source from TOPv2:
-- column value_micro format 999999999,999999 heading "Time(Micro)"
-- column value_sec   format 999999999        heading "Time(Sec)"
-- column pct   format a05 heading "%" justify right
-- 
-- with db_time as (
-- select sid, value
--   from v$sess_time_model
--  where sid = &sid
--    and stat_name = 'DB time'
-- )
-- select ses.stat_name        as statistic
--      , ses.value            as value_micro
--      , round(ses.value/1e6) as value_sec
--      , lpad(to_char(round(ses.value/nullif(tot.value,0)*1e2,2),'FM90.00'),5) as pct
--   from v$sess_time_model ses, db_time tot
--  where ses.sid = tot.sid
--    and ses.stat_name <> 'DB time'
--    and ses.value > 0
--  order by ses.value desc
-- ;

---------
-- EOF --
---------
