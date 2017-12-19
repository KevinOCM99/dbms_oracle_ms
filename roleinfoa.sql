--get table info by owner begin
--table info
ACCEPT table_name prompt 'Enter Role Name: ' 

alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

col admin_option for a5 heading ADMIN
col default_role for a7 heading DEFAULT
col GRANTED_ROLE for a40
col owner for a10;
col table_name for a30;
col grantee for a15;
col privilege for a40;
col grantable for a10;
--col hierarchy for a10;

--1.role definition
prompt ****************************************************************
prompt ****************************************************************
prompt ****role definition ...   
prompt ****************************************************************
prompt ****************************************************************
select *
from dba_roles
where ROLE like UPPER('&table_name%')
order by 1;

--2.role users
prompt ****************************************************************
prompt ****************************************************************
prompt ****users have this role ...   
prompt ****************************************************************
prompt ****************************************************************

select *
from dba_role_privs
where granted_role like UPPER('&table_name%')
order by 1;


--3.role permission
prompt ****************************************************************
prompt ****************************************************************
prompt ****permission of this role ...   
prompt ****************************************************************
prompt ****************************************************************

prompt *************************System privileges****************************

select *
from dba_sys_privs
where grantee in 
(
select ROLE
from dba_roles
where ROLE like UPPER('&table_name%')
)
order by 1;

prompt *************************Role privileges****************************

select *
from dba_role_privs
where grantee in
(
select ROLE
from dba_roles
where ROLE like UPPER('&table_name%')
)
order by 1;

prompt *************************Object privileges****************************

select grantee,owner,table_name,privilege,grantable
from dba_tab_privs
where grantee in 
(
select ROLE
from dba_roles
where ROLE like UPPER('&table_name%')
)
order by 1,2,3;




