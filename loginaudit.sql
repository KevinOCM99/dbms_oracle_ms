alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';

col userhost for a20;
col username for a15;
col terminal for a20;
col action_name for a10;
col returncode for 999999999;
col timestamp for a20;


select userhost,username,terminal,timestamp,action_name,returncode
from 
select *
from dba_audit_session
where rownum < 11
order by timestamp desc;

select userhost,username,terminal,timestamp,action_name,returncode
from dba_audit_session
where returncode = '1017'
and rownum < 11
order by timestamp desc;

select userhost,username,terminal,timestamp,action_name,returncode
from dba_audit_session
where returncode = '28000'
and rownum < 11
order by timestamp desc;
