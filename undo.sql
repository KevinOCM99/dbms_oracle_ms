---------------------------------------------------------------------------------------
-- KnownFirst : none                                                                 --
-- ScriptName : undo_usage.sql                                                       --
-- IntendedTo : Overview and Breakdown of UNDO Tablespaces' Usage                    --
-- DDictionay : dba_tablespaces;dba_data_files;dba_free_space;dba_undo_extents       --
-- Applicable : 11g                                                                  --
-- CreationOn : 20140625                                                             --
-- RevisionOn : 20140630 Online/Offline+ACTIVE/EXPIRED/UNEXPIRED                     --
---------------------------------------------------------------------------------------
ttitle off
set linesize 200 pagesize 100 heading on feedback on wrap on verify on
--clear columns breaks computes

column tablespace_name format a20 heading "UNDO|Tablespace"
column extendible format a10 heading "AUTO|Extendible"
column used format 999,999 heading "ALLOCATED|Used(MB)"
column cur_free format 999,999 heading "ALLOCATED|Free(MB)"
column cur_size format 999,999 heading "ALLOCATED|Used+Free(MB)"
column cur_pct format a09 heading "ALLOCATED|Usage" justify right
column split_line format a02 heading ":)|:P"
column ext_size format 999,999 heading "UNALLOCATED|Ext(MB)"
column max_free format 999,999 heading "MAX_FREE|Free+Ext(MB)"
column max_size format 999,999 heading "MAX_SIZE|Used+Free+Ext(MB)"
column max_pct format a06 heading "MAX| Usage" justify right

with t as (
select ts.tablespace_name                       as tablespace_name
     , round(sum(df.bytes)/1024/1024)           as cur_size
     , round(sum(nvl(df.maxbytes,0))/1024/1024) as max_size
     , round(sum(nvl(fs.bytes,0))/1024/1024)    as cur_free
  from dba_tablespaces ts
  left outer
  join dba_data_files df
    on ts.tablespace_name=df.tablespace_name
  left outer
  join dba_free_space fs
    on ts.tablespace_name=fs.tablespace_name
where 1=1
   and ts.contents='UNDO'
   and ts.status='ONLINE'
group by ts.tablespace_name
)
select tablespace_name as tablespace_name
     , decode(sign(max_size-cur_size),1,'YES','NO') as extendible
     , (cur_size-cur_free) as used
     , cur_free as cur_free
     , cur_size as cur_size
     , lpad(ltrim(to_char(round((cur_size-cur_free)/nullif(cur_size,0)*100,2),'999.00')||'%'),9,' ') as cur_pct     
  from t
order by tablespace_name
/


with t as (
select ts.tablespace_name                       as tablespace_name
     , round(sum(df.bytes)/1024/1024)           as cur_size
     , round(sum(nvl(df.maxbytes,0))/1024/1024) as max_size
     , round(sum(nvl(fs.bytes,0))/1024/1024)    as cur_free
  from dba_tablespaces ts
  left outer
  join dba_data_files df
    on ts.tablespace_name=df.tablespace_name
  left outer
  join dba_free_space fs
    on ts.tablespace_name=fs.tablespace_name
where 1=1
   and ts.contents='UNDO'
   and ts.status='ONLINE'
group by ts.tablespace_name
)
select tablespace_name as tablespace_name
     , decode(sign(max_size-cur_size),1,'YES','NO') as extendible
     , decode(sign(max_size-cur_size),1,max_size-cur_size,null)       as ext_size
     , decode(sign(max_size-cur_size),1,max_size-(cur_size-cur_free)) as max_free
     , decode(sign(max_size-cur_size),1,max_size,null)                         as max_size
     , decode(sign(max_size-cur_size),1,lpad(ltrim(to_char(round((cur_size-cur_free)/max_size*100,2),'999.00')||'%'),6,' ')) as max_pct
  from t
order by tablespace_name
/

column tablespace_name format a20     heading "Undo Tablespace Name"
column segment_name    format a30     heading "Segment Name"
column segment_status  format a20     heading "Segment Status"
column extent_status   format a09     heading "Extent Status"
column mbytes          format 999999  heading "Size(MB)"

break on tablespace_name skip1

select s.tablespace_name
   --, s.segment_name
     , s.status                    as segment_status /* OFFLINE/ONLINE/NEEDS RECOVERY/PARTLY AVAILABLE/UNDEFINED */
     , e.status                    as extent_status  /* ACTIVE/EXPIRED/UNEXPIRED */
     , round(sum(bytes)/1024/1024) as mbytes
  from dba_rollback_segs s
right outer join
       dba_undo_extents  e
    on (s.tablespace_name=e.tablespace_name and s.segment_name=e.segment_name)
where 1=1
group by rollup(s.tablespace_name,s.status,e.status)
order by s.tablespace_name,e.status,s.status
/


col tablespace_name for a25;
col file_name for a40;
col size_mb for 999999999;
col retention for a15;
select f.tablespace_name,f.file_name,f.bytes/1024/1024 SIZE_MB,tbs.retention
from dba_data_files f,
dba_tablespaces tbs
where f.tablespace_name = tbs.tablespace_name
and tbs.contents ='UNDO'
order by 1,2
/
