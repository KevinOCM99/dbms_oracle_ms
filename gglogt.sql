select OWNER,TABLE_NAME,LOG_GROUP_NAME,LOG_GROUP_TYPE 
from dba_log_groups
order by 1,2;