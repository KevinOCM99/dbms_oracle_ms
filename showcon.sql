col con_name for a20 heading "Container Name"
select sys_context('userenv', 'con_name') con_name from dual;