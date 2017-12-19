col table_name for a20;
col trigger_name for a30;
col status for a10;
col trigger_type for a20;
col triggering_event for a30;

select table_name,trigger_name, status,trigger_type,triggering_event
from dba_triggers
where base_object_type not like 'DATABASE%'
and table_owner like upper('%&schema%')
and table_name like upper('%&tbl_name%')
order by 1,2;

