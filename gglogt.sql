col log_group_name for a30
select OWNER,TABLE_NAME,LOG_GROUP_NAME,LOG_GROUP_TYPE 
from dba_log_groups
order by 1,2;
