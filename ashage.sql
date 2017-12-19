SET ECHO OFF TERMOUT ON LINESIZE 200 PAGESIZE 50 NEWPAGE 1 FEEDBACK 10 VERIFY OFF WRAP ON HEADING ON
----------------------------------------------------------------------------------------------------
-- FILE NAME  : ASH_TIME.SQL                                                                      --
-- PARAMETER  : NONE                                                                              --
-- DEPENDENCY : N/A                                                                               --
-- CATEGORY   : QUERY / [FUNCTION] / WRAPPER / DISPATCHER / CONSTRUCTOR                           --
-- PURPOSE    :                                                                                   --
-- SOURCE     : GV$ACTIVE_SESSION_HISTORY ; DBA_HIST_ACTIVE_SESS_HISTORY                          --
-- TESTED     : 11G, 12C                                                                          --
-- CREATED    : 2014-10-10                                                                        --
-- REVISED    : 2015-08-24                                                                        --
-- LOCATION   : DBA\PERFORMANCE\ASH                                                               --
-- CHANGE #1  : 2015-08-24                                                                        --
----------------------------------------------------------------------------------------------------
BREAK ON DICTIONARY_NAME
------------
-- COLUMN --
------------
COLUMN DICTIONARY_NAME FORMAT A30     HEADING "DICTIONARY|NAME"
COLUMN INST_ID         FORMAT 9999    HEADING "INST|ID"
COLUMN MIN_SAMPLE_TIME FORMAT A20     HEADING "UTMOST|SAMPLE"
COLUMN MAX_SAMPLE_TIME FORMAT A20     HEADING "RECENT|SAMPLE"
COLUMN TIME_SPAN       FORMAT A24     HEADING "TIME|SPAN"
COLUMN HOUR_SPAN       FORMAT 99999   HEADING "HOUR|SPAN"
COLUMN DAY_SPAN        FORMAT 9999    HEADING "DAY|SPAN"
COLUMN CURRENT_TIME    FORMAT A20     HEADING "CURRENT|SYSTIME"

----------------------
-- COLUMN NEW_VALUE --
----------------------
SET TERMOUT OFF

COLUMN CURRENT_TIME NEW_VALUE NOW

select to_char(sysdate,'yyyy-mm-dd/hh24:mi:ss') as current_time
  from dual
;

COLUMN MAX_SAMPLE_TIME FORMAT A20 HEADING "RECENT|&NOW."

SET TERMOUT ON

-----------
-- TITLE --
-----------
PROMPT .........................
PROMPT > ASH, HOW OLD ARE YOU? <
PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^

-----------
-- QUERY --
-----------
select 'GV$ACTIVE_SESSION_HISTORY'                             as dictionary_name
     , inst_id                                                 as inst_id
     , to_char(min_sample_time,'yyyy-mm-dd/hh24:mi:ss')        as min_sample_time
     , to_char(max_sample_time,'yyyy-mm-dd/hh24:mi:ss')        as max_sample_time
     , max_sample_time-min_sample_time                         as time_span
     , extract(day  from (max_sample_time-min_sample_time))*24+
       extract(hour from (max_sample_time-min_sample_time))    as hour_span
     , extract(day  from (max_sample_time-min_sample_time))    as day_span
   --, to_char(sysdate,'yyyy-mm-dd/hh24:mi:ss')                as current_time
  from (
         select inst_id          as inst_id
              , max(sample_time) as max_sample_time
              , min(sample_time) as min_sample_time
           from gv$active_session_history
          group by inst_id
       )
union all
select 'DBA_HIST_ACTIVE_SESS_HISTORY'                          as dictionary_name
     , inst_id                                                 as inst_id
     , to_char(min_sample_time,'yyyy-mm-dd/hh24:mi:ss')        as min_sample_time
     , to_char(max_sample_time,'yyyy-mm-dd/hh24:mi:ss')        as max_sample_time
     , max_sample_time-min_sample_time                         as time_span
     , extract(day  from (max_sample_time-min_sample_time))*24+
       extract(hour from (max_sample_time-min_sample_time))    as hour_span
     , extract(day  from (max_sample_time-min_sample_time))    as day_span
   --, to_char(sysdate,'yyyy-mm-dd/hh24:mi:ss')                as current_time
  from (
         select instance_number  as inst_id
              , max(sample_time) as max_sample_time
              , min(sample_time) as min_sample_time
           from dba_hist_active_sess_history
          group by instance_number
       )
 order by dictionary_name desc
        , inst_id
/

--------------
-- TEARDOWN --
--------------
CLEAR BREAKS
---------
-- EOF --
---------
