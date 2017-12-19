-------------------------------------------------------
-- Query Usage  : @ts_grow                           --
-- Purpose      : Track Tablespace Growth Trend      --
-- DBMS Version : 11.2.0.3.0                         --
-- Update Date  : 20131212-20140206                  --
-------------------------------------------------------
ttitle off
clear columns breaks computes
set linesize 180 pagesize 80 heading off feedback off verify off

prompt Following Permanent Tablepspace Usgae Now Above Alert Threshold:
with data as (
select d.tablespace_name
     , nvl(         u.tbs_bytes,0) as          tbs_size
     , nvl(     u.max_tbs_bytes,0) as      max_tbs_size
     , nvl(u.real_max_tbs_bytes,0) as real_max_tbs_size
     , nvl(    f.free_tbs_bytes,0) as     free_tbs_size
  from dba_tablespaces d
     , (select tablespace_name
             , count(1)                                         as dbf_count
             , sum(bytes)                                       as          tbs_bytes
             , sum(maxbytes)                                    as      max_tbs_bytes
             , sum(decode(autoextensible,'YES',maxbytes,bytes)) as real_max_tbs_bytes
          from dba_data_files
         group by tablespace_name) u
     , (select tablespace_name
             , sum(bytes)                                       as     free_tbs_bytes
          from dba_free_space
         group by tablespace_name) f
where contents='PERMANENT'
  and d.tablespace_name = u.tablespace_name(+)
  and d.tablespace_name = f.tablespace_name(+)
), pct as (
select tablespace_name                                             as ts_name
     , round((real_max_tbs_size-tbs_size+free_tbs_size)/1024/1024) as free_tbs_mb
     , round((tbs_size-free_tbs_size)/real_max_tbs_size*100,2)     as use_pct
  from data
)
select listagg(ts_name||'('||ltrim(to_char(use_pct,'90.00'))||'%,Free'||free_tbs_mb||'MB)',', ')
       within group (order by use_pct desc) as ts_name
  from pct
 where use_pct>60
;
prompt
--------------------------------------------------------------------------------------------------------------------------------
set linesize 180 pagesize 80 heading on feedback 1 verify off
column week_day    format a15     heading "Week_Day"
column ts_name     format a30     heading "Tablespace_Name"
column cur_size_mb format 9999999 heading "Allocated(MB)"
column use_size_mb format 9999999 heading "Used(MB)"
column incr_mb     format 9999999 heading "Increment(MB)"

break on ts_name skip page
compute avg label 'Daily Increment(MB):' of incr_mb on ts_name

accept ts_nm prompt "Which tablepspace above you're interested to track? "

with dat as (
select d.tablespace_name
     , nvl(         u.tbs_bytes,0) as          tbs_size
     , nvl(     u.max_tbs_bytes,0) as      max_tbs_size
     , nvl(u.real_max_tbs_bytes,0) as real_max_tbs_size
     , nvl(    f.free_tbs_bytes,0) as     free_tbs_size
  from dba_tablespaces d
     , (select tablespace_name
             , count(1)                                         as dbf_count
             , sum(bytes)                                       as          tbs_bytes
             , sum(maxbytes)                                    as      max_tbs_bytes
             , sum(decode(autoextensible,'YES',maxbytes,bytes)) as real_max_tbs_bytes
          from dba_data_files
         group by tablespace_name) u
     , (select tablespace_name
             , sum(bytes)                                       as     free_tbs_bytes
          from dba_free_space
         group by tablespace_name) f
where contents='PERMANENT'
  and d.tablespace_name = u.tablespace_name(+)
  and d.tablespace_name = f.tablespace_name(+)
), pct as (
select tablespace_name as ts_name
     , round((tbs_size-free_tbs_size)/real_max_tbs_size*100,2) as use_pct
  from dat
 where 1=1
 --and round((tbs_size-free_tbs_size)/real_max_tbs_size*100,2)>80
), tmp as (
select ts.tsname                                                         as ts_name
     , to_char(sp.begin_interval_time,'yyyy-mm-dd')                      as temp_day
     , max(round((tsu.tablespace_size*dt.block_size)/(1024*1024),0) )    as cur_size_mb
     , max(round((tsu.tablespace_usedsize*dt.block_size)/(1024*1024),0)) as use_size_mb
  from dba_hist_tbspc_space_usage tsu
     , dba_hist_tablespace_stat   ts
     , dba_hist_snapshot          sp
     , dba_tablespaces            dt
     ,                            pct
 where 1=1
   and tsu.tablespace_id = ts.ts#
   and tsu.snap_id       = sp.snap_id
   and dt.contents       = 'PERMANENT'
   and ts.tsname         = dt.tablespace_name
   and ts.tsname         like nvl(upper('&ts_nm'),pct.ts_name)
 group by ts.tsname, to_char(sp.begin_interval_time,'yyyy-mm-dd')
 order by ts.tsname, temp_day
)
select tmp.ts_name||'('||ltrim(to_char(use_pct,'90.00'))||'%)' as ts_name
     , decode((1+trunc(to_date(temp_day,'yyyy-mm-dd'))-trunc(to_date(temp_day,'yyyy-mm-dd'),'IW'))
                             ,1,temp_day||'(Mon)'
                             ,2,temp_day||'(Tue)'
                             ,3,temp_day||'(Wed)'
                             ,4,temp_day||'(Thu)'
                             ,5,temp_day||'(Fri)'
                             ,6,temp_day||'(Sat)'
                             ,7,temp_day||'(Sun)') as week_day
     , cur_size_mb
     , use_size_mb
     , use_size_mb-lag(use_size_mb,1,null)over(partition by tmp.ts_name
                                                   order by tmp.ts_name,temp_day) as incr_mb
  from tmp, pct
 where tmp.ts_name=pct.ts_name
/
