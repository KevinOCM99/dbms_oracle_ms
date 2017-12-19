select supplemental_log_data_min min,
       supplemental_log_data_pk pk,
       supplemental_log_data_ui ui,
       supplemental_log_data_fk fk,
       supplemental_log_data_all "ALL"
from v$database;


col owner for a15;
col table_name for a20;
col LOG_GROUP_NAME for a20;
col LOG_GROUP_TYPE for a30;
select OWNER,TABLE_NAME,LOG_GROUP_NAME,LOG_GROUP_TYPE 
from dba_log_groups
order by 1,2,3;

col owner for a15;
col table_name for a20;
col COLUMN_NAME for a20;
col POSITION for 999;
col LOGGING_PROPERTY      for a30;
select OWNER,TABLE_NAME,LOG_GROUP_NAME,COLUMN_NAME,POSITION,LOGGING_PROPERTY
from dba_log_group_columns
order by 1,2,3;
