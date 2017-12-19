-------------------
-- INTIALIZATION --
-------------------
ttitle off
undefine sql_txt
clear columns breaks computes
set echo off termout on verify off

----------------------------------------------------------------------------------------------------
-- Ask4 : A Piece of SQL Text                                                                     --
-- Name : sql_t2i.sql (v2)                                                                        --
-- Todo : Give me a word, I'll give you the world                                                 --
-- View : GV$SQLAREA ; DBA_HIST_SQLTEXT ; DBA_HIST_ACTIVE_SESS_HISTORY                            --
-- Tool : none                                                                                    --
-- Base : 11g                                                                                     --
-- Born : 2014-11-05                                                                              --
-- Fix1 : 2015-04-28, Add and Order by LAST_LOAD_TIME & LAST_ACTIVE_TIME                          --
-- Fix2 : 2015-04-30, Join DBA_HIST_ACTIVE_SESS_HISTORY                                           --
-- Path : DBA/Performance/Find                                                                    --
----------------------------------------------------------------------------------------------------
---------------
-- PARAMETER --
---------------
accept sql_txt prompt "SQL Text Piece (Your Input => '%YOURINPUT%') : "

-------------
-- COLUMNS --
-------------
column sql_id           format a013 heading "SQL_ID"
column sql_text         format a124 heading "SQL_TEXT" truncated
column last_load_time   format a019 heading "LAST_LOAD_TIME"
column last_active_time format a019 heading "LAST_ACTIVE_TIME"
column flag             format a001 heading "F"

----------------
-- QUERY BODY --
----------------
with mem as (
select /* ewan */
       'M'                                               as flag
     , to_char(last_load_time  ,'yyyy-mm-dd_hh24:mi:ss') as last_load_time
     , to_char(last_active_time,'yyyy-mm-dd_hh24:mi:ss') as last_active_time
     , sql_id
     , trim(dbms_lob.substr(sql_text,4000,1)) as sql_text
  from gv$sqlarea a
 where trim(regexp_replace(replace(replace(upper(a.sql_text)  ,chr(10),' '),chr(13),' '),'( ){2,}','\1'))
  like trim(regexp_replace(replace(replace(upper('%&sql_txt%'),chr(10),' '),chr(13),' '),'( ){2,}','\1'))
   and a.sql_text not like '%select /* ewan */%'
), his as (
select 'H'                              as flag
     , null
     , null
     , sql_id
     , trim(dbms_lob.substr(sql_text,4000,1)) as sql_text
  from dba_hist_sqltext b
 where b.dbid=(select dbid from v$database)
   and trim(regexp_replace(replace(replace(upper(b.sql_text)  ,chr(10),' '),chr(13),' '),'( ){2,}','\1'))
  like trim(regexp_replace(replace(replace(upper('%&sql_txt%'),chr(10),' '),chr(13),' '),'( ){2,}','\1'))
   and b.sql_text not like '%select /* ewan */%'
), his2 as (
select t.flag
     , to_char(max(s.SQL_EXEC_START),'yyyy-mm-dd_hh24:mi:ss') as last_load_time
     , to_char(max(s.SAMPLE_TIME   ),'yyyy-mm-dd_hh24:mi:ss') as last_active_time
     , t.sql_id
     , t.sql_text
  from his t
  left outer
  join DBA_HIST_ACTIVE_SESS_HISTORY s
    on t.sql_id=s.sql_id
 group by t.flag, t.sql_id, t.sql_text
)
select * from his2
 union all
select * from mem
 order by 1,2,3
/

--------------
-- TEARDOWN --
--------------
undefine sql_txt
clear columns

---------
-- EOF --
---------
