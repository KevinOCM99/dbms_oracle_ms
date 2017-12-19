BREAK ON tablespace_name SKIP 2
--COMPUTE SUM OF allocated_Mbytes, free_Mbytes ON DUMMY
COMPUTE SUM LABEL 'Sum Free' OF free_Mbytes ON tablespace_name
COMPUTE SUM LABEL 'Sum Allo' OF allocated_Mbytes ON tablespace_name
COLUMN allocated_Mbytes FORMAT 9,999,999,999
COLUMN free_Mbytes FORMAT 9,999,999,999
COLUMN MAXBYTES FORMAT 9,999,999,999 heading MAX_MBYTES
column file_name for a50;
column extensible               format a1       heading "E|x"
col id for 9999;
set lines 180;

SELECT a.tablespace_name,a.file_id ID, a.file_name,decode(AUTOEXTENSIBLE,'YES','Y','NO','N')   as extensible, a.bytes/1024/1024 allocated_Mbytes, 
 b.free_Mbytes,a.MAXBYTES/1024/1024 MAXBYTES
 FROM 
(
select tablespace_name,file_id,file_name,AUTOEXTENSIBLE,bytes,MAXBYTES
from dba_data_files 
union all
select tablespace_name,file_id,file_name,AUTOEXTENSIBLE,bytes,MAXBYTES
from dba_temp_files
) a, 
(SELECT file_id, SUM(bytes) /1024/1024  free_Mbytes
FROM dba_free_space b GROUP BY file_id) b
WHERE a.file_id = b.file_id(+)
and a.tablespace_name like upper('%&tbs_name%')
ORDER BY a.tablespace_name,a.file_id;

clear breaks;