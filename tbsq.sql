set lines 120
col TABLESPACE_NAME        for a30
col USERNAME               for a20
col BYTES_MB for 9999999999
col MAX_MB for 9999999999
select TABLESPACE_NAME,USERNAME,BYTES/1024/1024 BYTES_MB,MAX_BYTES/1024/1024 MAX_MB
from dba_ts_quotas
where TABLESPACE_NAME like upper('%&ts%')
and username like upper('%&user%')
order by 1,2;
