set pages 999 lines 120;
col comp_name for a50
col version for a20
select comp_name,version
from dba_registry
order by 1;
