--get table info by owner begin
--table info
ACCEPT table_name prompt 'Enter Permission Name: ' 

col admin_option justify right for a5 heading ADMIN
col grantee for a45;
col privilege for a30;

prompt *************************User/Role List having current permission****************************
select privilege,case when b.role is null then '[USER]' else '[ROLE]' end || ' ' || grantee grantee,admin_option
from dba_sys_privs a left join dba_roles b on a.grantee  = b.role
where a.privilege like UPPER('&table_name%')
order by 1,2;