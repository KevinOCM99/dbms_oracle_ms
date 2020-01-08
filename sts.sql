col name for a45;
col owner for a20;
select name, owner, CREATED, LAST_MODIFIED, statement_count from dba_sqlset order by 2,1;

col sqlset_name for a30;
col statement_count for 999;
select count(*) statement_count, sqlset_name from dba_sqlset_statements group by sqlset_name;