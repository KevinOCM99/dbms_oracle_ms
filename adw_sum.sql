@cls
--set timing on;
--set echo on;
--instance
col INSTANCE_NUMBER for 999 heading AID;
col parallel for a8;
col instance_mode for a15;
col database_type for a15;
select INSTANCE_NUMBER,instance_name,to_char(startup_time,'yyyy-mm-dd hh24:mi:ss') startup_time,parallel,instance_mode,database_type from v$instance;

--cpu
show parameter cpu;

--@dir
col directory_name for a30;
col directory_path for a80;
SELECT directory_name, directory_path
FROM   dba_directories order by 1;
--tbs and data file
col tablespace_name for a20;
col file_name for a105;
select tablespace_name,file_name from dba_data_files order by 1;
--version
col banner_full for a79 heading VERION_FULL;
select banner_full from v$version;
--
show parameter compatible;

--@pdb
col name for a30 heading ADB_FULL_NAME;
col open_mode for a20;
col con_id for 999;
col creation_TIME for a20 heading PROVISIONING_TIME;
col total_size_MB for 999999;
select con_id, name, open_mode,to_char(creation_time,'yyyy-mm-dd hh24:mi:ss') creation_time,total_size/1024/1024 total_size_MB,guid
from v$pdbs;
--
--set timing off;
--set echo off;
