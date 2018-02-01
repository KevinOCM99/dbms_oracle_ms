set feed off
set head off
set echo off
set term off
set linesize 120
set verify off
spool myloop_tmp.sql
set feedback off
set feed off
set serveroutput on 
select cmd from (
select '@' || '&1'  as cmd from dual
union all
select 'exec dbms_lock.sleep(&2);' as cmd from dual
union all
select 'clear scr' as cmd from dual
) , (select rownum from dual connect by level <=&3) ;
spool off
set term on
set serveroutput on
set head on
--clear scr
@login
clear scr
@myloop_tmp.sql
host rm myloop_tmp.sql

