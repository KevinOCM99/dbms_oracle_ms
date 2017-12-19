set lines 180
col command for a30;
col rule_set_name for a50;
col object_owner for a10 heading owner
col object_name for a10 heading name
col enable for a6
col privilege_scope for a20;
select * 
from DVSYS.DBA_DV_COMMAND_RULE;