clear columns;
col owner for a15;
col index_name for a20;
col index_type for a10;
col table_owner for a15;
col table_name for a20;
col UNIQUENESS for a10;
col TABLESPACE_NAME for a20;
select OWNER          
,INDEX_NAME     
,INDEX_TYPE     
,TABLE_OWNER    
,TABLE_NAME     
,UNIQUENESS     
,TABLESPACE_NAME
from dba_indexes
where owner like upper('&owner')
and index_name like upper('&inx_name');