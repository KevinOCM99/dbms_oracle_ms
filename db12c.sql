-- To get the database, host, user information
-- Created by Junyi Liang 2010/9/17
col db_name format a15
col host_name format a40
col user_name format a15
col terminal_name format a30
col con_name for a15
col CDB for a3
set lines 180

SELECT host_name,
       INSTANCE_NAME INSTANCE,
       SYS_CONTEXT('USERENV', 'CON_NAME') CON_NAME,
       CDB,
       sys_context('USERENV', 'CURRENT_SCHEMA') user_name,
       sys_context('USERENV','HOST') terminal_name
FROM V$INSTANCE, v$database;

select *
from v$version;