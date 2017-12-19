--get table info by owner begin
--table info
ACCEPT schema_name prompt 'Enter USER: ' 
ACCEPT table_name prompt 'Enter Object Name: ' 
col owner for a10;
col table_name for a30;
col grantor for a15;
col privilege for a40;
col GRANTEE for a30;

--1.table definition
prompt ****************************************************************
prompt ****************************************************************
prompt ****As grantee ...   
prompt ****************************************************************
prompt ****************************************************************
select owner,table_name,PRIVILEGE
from dba_tab_privs
where grantee=UPPER('&schema_name')
and table_name like upper('&table_name') || '%'
order by 1,2,3;

--2.table storage information
prompt ****************************************************************
prompt ****************************************************************
prompt ****As Owner ...
prompt ****************************************************************
prompt ****************************************************************

select GRANTEE,table_name,PRIVILEGE
from dba_tab_privs
where owner=UPPER('&schema_name')
and table_name like upper('&table_name') || '%'
order by 1,2,3;

