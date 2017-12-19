
set linesize 120 pagesize 100
column db_id               format 999999999999
column db_name             format a08
column inst_id             format 9
column inst_name           format a9
column inst_status         format a11
column last_startup_time   format a19
column inst_startup_time   format a19
column begin_date 	   format a10 justify right
column begin_time          format a10
column end_date            format a10 WORD_WRAPPED 
column end_time            format a8
column snap_id             format 999999
--BREAK ON DB_ID on db_name on inst_name on inst_status on inst_startup_time
clear break
break on inst_startup_time skip page on BEGIN_DATE on END_DATE
accept hours prompt "Please input how many hours? "
select c.dbid                                                 as db_id
     , c.name                                                 as db_name
--     , b.inst_id                                            as inst_id
     , b.instance_name                                        as inst_name
     , b.status                                               as inst_status
     , to_char(b.startup_time,'yyyy-mm-dd hh24:mi:ss')	      as last_startup_time
  from v$instance       b
     , v$database        c
/
select to_char(a.startup_time,'yyyy-mm-dd hh24:mi:ss')	      as inst_startup_time        
     , to_char(a.begin_interval_time,'yyyy-mm-dd') 	      as begin_date
     , to_char(a.begin_interval_time,'hh24:mi') 	      as begin_time
     , to_char(a.end_interval_time,'yyyy-mm-dd')   	      as end_date
     , to_char(a.end_interval_time,'hh24:mi')                as end_time
     , a.snap_id
  from dba_hist_snapshot a
     , v$instance       b
     , v$database        c
 where a.instance_number=b.instance_number
 --and a.end_interval_time>timestamp'2013-09-12 08:00:00'
   and a.end_interval_time>systimestamp-1/24*&&hours
 --  and a.instance_number=1
 order by snap_id,begin_interval_time
/

