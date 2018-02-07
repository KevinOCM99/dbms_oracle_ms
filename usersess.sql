set lines 999;
col username for a20;
col osuser for a15;
col machine for a20;
col program for a40;
col terminal for a20;
col sess_id for a20;
select username,osuser,machine,'''' || to_char(sid) || ',' || serial# || ',@' || INST_ID || '''' sess_id,terminal,program
from gv$session
where username like upper('%&1%')
order by 1;
