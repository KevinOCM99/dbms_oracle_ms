set lines 180 pages 999
col inst_id for 99
col group# for 99
col THREAD# for 99
col status for a15
col ARCHIVED for a9
col MEMBERS for 99
col SIZE_MB for 99999999
select INST_ID,GROUP#,THREAD#,SEQUENCE#,MEMBERS,ARCHIVED,STATUS,BYTES / 1024 / 1024 AS SIZE_MB
from gv$log
order by 1,2;

col USED for 999999999;
select INST_ID,GROUP#,THREAD#,SEQUENCE#,USED,ARCHIVED,STATUS,BYTES / 1024 / 1024 AS SIZE_MB
from gv$standby_log order by 1,2;
