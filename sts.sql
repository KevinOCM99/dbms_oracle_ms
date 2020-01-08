col name for a45;
col owner for a20;
select name, owner, CREATED, LAST_MODIFIED, statement_count from dba_sqlset order by 2,1;

col sqlset_name for a30;
col parsing_schema_name for a20 heading SCHEMA_NAME;
col sql_text for a80
select sqlset_name,sql_seq,parsing_schema_name,to_char(substr(sql_text,1,80)) sql_text 
from dba_sqlset_statements 
where parsing_schema_name not in ('LBACSYS','SYS','SYSTEM') 
order by sqlset_name,sql_seq;
