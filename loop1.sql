--every 3s repeat 100 times
--@loop1 test.sql 3 100 
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
select 'host echo' as cmd from dual
union all
select 'host source p_delay.kk &2' as cmd from dual
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

