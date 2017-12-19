-------------------------------------------------------------------------------------------------
-- KnownFirst : none                                                                           --
-- ScriptName : db_time_top.sql                                                                --
-- 1stEAuthor : Kerry Osborne                                                                  --
-- IntendedTo : Find busiest time periods in AWR.                                              --
-- DDictionay : DBA_HIST_SNAPSHOT; FROM DBA_HIST_SYS_TIME_MODEL                                --
-- Applicable : 11g                                                                            --
-- CreationOn : 20140825                                                                       --
-- RevisionOn : 20140825                                                                       --
-------------------------------------------------------------------------------------------------
set linesize 200 pagesize 50

set heading off feedback off
select rpad('#',38,'#')||chr(10)||
       '# DB 30 Busiest Moments in Last Week #'||chr(10)||
       rpad('#',38,'#')
  from dual;
set heading on feedback 1

clear columns breaks computes
column begin_date          format a15         heading "Begin_Date"
column begin_time          format a08         heading "and_Time"
column interval_mins       format 999         heading "Interval(Mins)"
column DBtime_mins         format 999,999.00  heading "DBTime(Mins)"
column DBtime_secs         format 999,999,999 heading "DBTime(Secs)"
column inst_id             format 9           heading "IID"

break on begin_date on begin_time

select decode((1+trunc(to_date(substr(begin_interval_time,1,10),'yyyy-mm-dd'))-trunc(to_date(substr(begin_interval_time,1,10),'yyyy-mm-dd'),'IW'))
                             ,1,substr(begin_interval_time,1,10)||'(Mon)'
                             ,2,substr(begin_interval_time,1,10)||'(Tue)'
                             ,3,substr(begin_interval_time,1,10)||'(Wed)'
                             ,4,substr(begin_interval_time,1,10)||'(Thu)'
                             ,5,substr(begin_interval_time,1,10)||'(Fri)'
                             ,6,substr(begin_interval_time,1,10)||'(Sat)'
                             ,7,substr(begin_interval_time,1,10)||'(Sun)') as begin_date
     , substr(begin_interval_time,12,8) as begin_time
     , inst_id
     , begin_snap_id
     , end_snap_id
     , interval_mins
     , DBtime_mins
   --, DBtime_secs
  from (
select to_date(trunc(begin_interval_time,'hh24')+floor(to_char(begin_interval_time,'mi')/5)*5/1440
              /* round timestamp to nearest 5 minutes, notice that the value type of rounded data is DATE! */
              ,'yyyy-mm-dd hh24:mi:ss') as begin_interval_time
     , inst_id
     , begin_snap_id
     , end_snap_id
     , round((cast(end_interval_time as date)-cast(begin_interval_time as date))*1440) as interval_mins
     , a/1000000/60     as DBtime_mins
     , round(a/1000000) as DBtime_secs
  from (select e.snap_id                                                              as end_snap_id
             , lag(e.snap_id)          over(order by e.instance_number,e.snap_id)     as begin_snap_id
             , lag(s.end_interval_time)over(order by e.instance_number,e.snap_id)     as begin_interval_time
               /* end_interval_time of begin_snap_id is indeed the begin_interval_time of reported period */
             , s.end_interval_time
             , s.instance_number                                                      as inst_id
           --, e.value
             , nvl(e.value-lag(e.value) over(order by e.instance_number,e.snap_id),0) as a
          from dba_hist_sys_time_model e
             , dba_hist_snapshot       s
         where s.snap_id=e.snap_id
           and e.instance_number=s.instance_number
           and e.stat_name='DB time'
           and s.end_interval_time>systimestamp-7 /*Time Limit*/
       )
 where 1=1
   and begin_snap_id=end_snap_id-1
 order by DBtime_mins desc
)where rownum <=30
 order by begin_date,begin_time,inst_id
/
