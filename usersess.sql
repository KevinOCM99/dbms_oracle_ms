set lines 999;
col username for a20;
col osuser for a15;
col machine for a25;
col program for a45;
col terminal for a20;
col sess_id for a20;
col resource_consumer_group for a15 heading CONSUMER_GROUP;
select username,osuser,machine,'''' || to_char(sid) || ',' || serial# || ',@' || INST_ID || '''' sess_id,terminal,resource_consumer_group,program
from gv$session
where username like upper('%&9%')
order by 1;
