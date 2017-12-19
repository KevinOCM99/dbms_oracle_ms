prompt FSR_ADMIN 
prompt FUNDFACTDB
ACCEPT schema_name prompt 'Enter Owner: ' 
ACCEPT table_name prompt 'Enter Name: ' 
col owner for a20
col db_link for a30
col host for a25
col username for a20
select *
from dba_db_links
WHERE  owner like UPPER('&schema_name%')
and db_link like UPPER('&table_name%')
order by 1,2;