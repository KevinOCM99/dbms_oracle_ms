col inst_id for 99;
col name for a30;
col value for a70;
select inst_id,name,value
from v$diag_info
order by 1,2;