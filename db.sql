-- To get the database, host, user information
-- Created by Junyi Liang 2010/9/17
set lines 180
col db_name format a15
col host_name format a27
col user_name format a15
col terminal_name format a30
col instance for a12;
col status for a10;


SELECT host_name,
       INSTANCE_NAME INSTANCE,
       sys_context('USERENV','DB_NAME') DB_NAME,
       status,
       sys_context('USERENV', 'CURRENT_SCHEMA') user_name,
       sys_context('USERENV','HOST') terminal_name,
       logins
FROM GV$INSTANCE;

@@ver
