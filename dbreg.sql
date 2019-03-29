col comp_name for a40;
col status for a20;
col version for a10;
col comp_id for a30
select comp_id, comp_name, status, substr(version,1,10) as version 
from dba_registry 
order by 1;

