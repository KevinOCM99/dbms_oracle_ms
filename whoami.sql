----------------------------------------------------------------------------------------------------
-- Query Name  : whoami.sql                                                                       --
-- Purpose     : Get WHOAMI from V$SESSION & V$MYSTAT                                             --
-- Birthday    : 2013-09-10                                                                       --
-- Revision    : 2014-04-23 Adding Feature: Show Trace File                                       --
-- Change #1   : 2015-05-05, Name Changed: id -> whoami                                           --
----------------------------------------------------------------------------------------------------
ttitle off
clear columns breaks computes
set linesize 200 pagesize 40 echo off termout on verify off
set heading on feedback 9 wrap on
--
column os_name    format a10
column os_type    format a07
column os_user    format a10
column db_user    format a10
column db_schema  format a10
column os_pid     format a08 justify right
column db_pid     format a12 justify right
column sid        format 999999
column sserial#   format 999999
column module     format a10
column logon_time format a11
column db_name    format a10
column db_open    format a07
column db_role    format a07

----------------
-- QUERY BODY --
----------------
select s.machine                             as os_name
     , decode(d.platform_name,'Linux x86 64-bit'          ,'Linux'
                             ,'AIX-Based Systems (64-bit)','AIX'
                             ,platform_name) as os_type
     , substr(s.module,1,instr(s.module,'@',1,1)-1) as module
     , s.osuser                              as os_user
     , lpad(p.spid,8,' ')                    as os_pid
     , lpad(s.process,12,' ')                as db_pid
     , s.sid                                 
     , s.serial#                             as sserial#
     , d.name                                as db_name
     , decode(d.open_mode,'READ WRITE'          ,'R/W'
                         ,'MOUNTED'             ,'Mntd'
                         ,'READ ONLY'           ,'R/O'
                         ,'READ ONLY WITH APPLY','ROwA'
                         ,open_mode)         as db_open
     , decode(d.database_role,'PHYSICAL STANDBY','Phy-Std'
                             ,'SNAPSHOT STANDBY','Snp-Std'
                             ,'PRIMARY'         ,'Primary'
                             ,database_role) as db_role
     , to_char(s.logon_time,'mm-dd hh24:mi') as logon_time
     , s.username                            as db_user
     , s.schemaname                          as db_schema
   --, s.program                             
  from v$session s left outer join v$process p on s.paddr=p.addr
     , v$database d
 where sid in (select sid from v$mystat)
;

set termout off feedback off serveroutput off
var v_tracefile  varchar2(200)
BEGIN
select value
  into :v_tracefile
  from v$diag_info
 where name = 'Default Trace File'
;
END;
/

set termout on feedback off serveroutput on size unlimited
exec IF :v_tracefile IS NOT NULL THEN DBMS_OUTPUT.PUT_LINE('Trace File: '||:v_tracefile); END IF

---------
-- EOF --
---------
