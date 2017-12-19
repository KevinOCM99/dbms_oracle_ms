col tablespace for a15;
col MB_TOTAL for 99999999
col MB_USED for 99999999
col MB_FREE for 99999999
SELECT A.tablespace_name tablespace, D.mb_total,
 SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
 D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free
 FROM v$sort_segment A,
 (
 SELECT B.name, C.block_size, SUM (C.bytes) / 1024 / 1024 mb_total
 FROM v$tablespace B, v$tempfile C
 WHERE B.ts#= C.ts#
 GROUP BY B.name, C.block_size
 ) D
 WHERE A.tablespace_name = D.name
 GROUP by A.tablespace_name, D.mb_total
order by 1;


col TABLESPACE_NAME for a15;
col TABLESPACE_SIZE for 999999999999999;
col ALLOCATED_SPACE for 999999999999999;
col FREE_SPACE for 999999999999999;
SELECT TABLESPACE_NAME,
TABLESPACE_SIZE/1024/1024 TABLESPACE_SIZE, 
ALLOCATED_SPACE/1024/1024 ALLOCATED_SPACE,
FREE_SPACE/1024/1024 FREE_SPACE
FROM dba_temp_free_space;


col tablespace_name for a15;
col file_name for a50;
col SIZE_MB for 999999;
col file_id for 9999;
column autoextensible format a3 heading "EXT";
break on tablespace_name
select tablespace_name,file_id,file_name,bytes/1024/1024 SIZE_MB,autoextensible,a.bound bound_mb
from dba_temp_files left outer join 
(select tablespace,max(segblk#) * 8192/1024/1024 bound
from v$sort_usage
group by tablespace) a on tablespace_name = a.tablespace
order by tablespace_name,file_id;
clear breaks;


col mb_used for 9999999
col username for a20;
col osuser for a10
col spid for a6
col tablespace for a15;
col statements for 999 heading CNT;
col sid_serial for a10;
col module for a15;
col program for a20;
col machine for a30 heading CLIENT_HOST;
col mb_bound for 9999999
break on tablespace;
SELECT   T.tablespace, SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used, S.username, S.sid || ',' || S.serial# sid_serial,
 COUNT(*) statements, max(segblk#) * TBS.block_size / 1024 / 1024 mb_bound, S.osuser, P.spid,s.machine
-- ,S.module
-- ,P.program
 FROM v$sort_usage T, v$session S, dba_tablespaces TBS, v$process P
 WHERE T.session_addr = S.saddr
 AND S.paddr = P.addr
 AND T.tablespace = TBS.tablespace_name
 GROUP BY S.sid, S.serial#, S.username, S.osuser, P.spid, 
-- S.module,  P.program, 
s.machine,
TBS.block_size, T.tablespace
 ORDER BY tablespace,mb_used desc,username,sid;
clear breaks;

col tablespace for a15;
col username for a20;
col status for a10;
col prev_exec_start for a20;
col sql_id for a15;
col sid for 99999;
col logon_time for a20;
break on tablespace;
select su.TABLESPACE,su.username,se.sid,se.prev_exec_start,se.status,su.sql_id,se.logon_time
from v$sort_usage su,v$session se
where se.saddr=su.session_addr
and tablespace in (
select tablespace_name
from dba_tablespaces
where contents = 'TEMPORARY')
order by 1,2,3;
clear breaks;