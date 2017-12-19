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

column tablespace_name format a20     heading "UNDO|Tablespace"
column used            format 999,999 heading "ALLOCATED|Used(MB)"
column cur_free        format 999,999 heading "ALLOCATED|Free(MB)"
column cur_size        format 999,999 heading "ALLOCATED|U+F(MB)"
column cur_pct         format a09     heading "ALLOCATED|Usage"
column split_line      format a02     heading ":)|:P"
column ext_size        format 999,999 heading "UNALLOCATED|E(MB)"
column max_free        format 999,999 heading "MAX_FREE|F+E(MB)"
column max_size        format 999,999 heading "MAX_SIZE|U+F+E(MB)"
column max_pct         format a06     heading "   MAX| Usage"

with df as (
select ts.tablespace_name                as tablespace_name
     , round(sum(df.bytes)/1024/1024)    as cur_size
     , round(sum(df.maxbytes)/1024/1024) as max_size
  from dba_tablespaces ts
     , dba_data_files  df
where ts.contents='UNDO'
   and ts.status='ONLINE'
   and ts.tablespace_name=df.tablespace_name
group by ts.tablespace_name
),  fs as (
select ts.tablespace_name                as tablespace_name
     , round(sum(fs.bytes)/1024/1024)    as cur_free
  from dba_tablespaces ts
     , dba_free_space  fs
where ts.contents='UNDO'
   and ts.status='ONLINE'
   and ts.tablespace_name=fs.tablespace_name(+)
group by ts.tablespace_name
)
select df.tablespace_name                                                                                    as tablespace_name
     , (df.cur_size-fs.cur_free)                                                                             as used
     , fs.cur_free                                                                                           as cur_free
     , df.cur_size                                                                                           as cur_size
     , lpad(ltrim(to_char(round((df.cur_size-fs.cur_free)/nullif(df.cur_size,0)*100,2),'99.00')||'%'),9,' ') as cur_pct
     , ':D'                                                                                                  as split_line
     , df.max_size-df.cur_size                                                                               as ext_size
     , df.max_size-(df.cur_size-fs.cur_free)                                                                 as max_free
     , df.max_size                                                                                           as max_size
     , lpad(ltrim(to_char(round((df.cur_size-fs.cur_free)/nullif(df.max_size,0)*100,2),'99.00')||'%'),6,' ') as max_pct
  from df, fs
where df.tablespace_name=fs.tablespace_name
order by df.tablespace_name
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


column tablespace_name heading "TBS" format a15; 
column name heading "UndoSegName" for a30;
column status for a15;
SELECT t.tablespace_name, n.NAME, s.status, s.extents, s.rssize, s.hwmsize, s.xacts
FROM v$rollname n, v$rollstat s , dba_rollback_segs t
WHERE n.usn = s.usn and t.segment_id = n.usn
order by 1,2
/


column UNXPSTEALCNT heading "# Unexpired|Stolen";
column EXPSTEALCNT heading "# Expired|Reused";
column SSOLDERRCNT heading "ORA-1555|Error";
column NOSPACEERRCNT heading "Out-Of-space|Error";
column MAXQUERYLEN heading "Max Query|Length";
column TUNED_UNDORETENTION heading "UndoRetention|Tuned";
column undoblks heading "BLKs" for 99999;
column INTVL for a5;
select to_char(begin_time,'MM/DD/YYYY HH24:MI') begin_time,
--TO_CHAR(END_TIME, 'MM/DD/YYYY HH24:MI') END_TIME,
trunc( mod( (END_TIME - begin_time)*24*60, 60 ) ) ||'Min' INTVL,
undoblks, 
UNXPSTEALCNT, EXPSTEALCNT , SSOLDERRCNT, NOSPACEERRCNT, TUNED_UNDORETENTION , MAXQUERYLEN 
from v$undostat 
where rownum < 15
order by begin_time desc
/

clear break
col sid_serial for a10
col PROGRAM for a15
col ORAUSER for a10
col undo for a15
col TABLESPACE_NAME for a20
SELECT TO_CHAR (s.SID) || ',' || TO_CHAR (s.serial#) sid_serial,
NVL (s.username, 'None') orauser, s.program, r.NAME undoseg,
t.used_ublk * TO_NUMBER (x.VALUE) / 1024 || 'K' "Undo",
t1.tablespace_name
FROM SYS.v_$rollname r,
SYS.v_$session s,
SYS.v_$transaction t,
SYS.v_$parameter x,
dba_rollback_segs t1
WHERE s.taddr = t.addr
AND r.usn = t.xidusn(+)
AND x.NAME = 'db_block_size'
AND t1.segment_id = r.usn;

@ms\lockobj.sql