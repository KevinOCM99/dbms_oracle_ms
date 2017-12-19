
--get table info by owner begin
--table info
ACCEPT table_name prompt 'Enter Object Name [Table, Index, Synonym etc.] : ' 

alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

set echo off;

col owner for a20;
col table_owner for a20;
col object_name for a30;
col synonym_name for a30;
col table_name for a30;
col object_type for a15;
col STATUS for a10;
col db_link for a15;
col object_id for 999999 heading id;
col grantee for a30;
col PRIVILEGE for a30;

--1.base object
prompt ****************************************************************
prompt ****************************************************************
prompt ****base object ...   
prompt ****************************************************************
prompt ****************************************************************
select owner,object_name,object_type,LAST_DDL_TIME,STATUS,object_id
from dba_objects
where object_name like UPPER('&table_name%')
order by 1,2,3;

prompt ****************************************************************
prompt ****************************************************************
prompt ****synonym ...   
prompt ****************************************************************
prompt ****************************************************************
select owner,synonym_name,table_owner,table_name,db_link
from dba_synonyms
where synonym_name like UPPER('&table_name%')
order by 1,2,3;