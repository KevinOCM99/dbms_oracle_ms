col owner for a10;
col trigger_type for a13;
col triggering_event for a20;
col trigger_name for a50;
col status for a8;
select owner,trigger_type,triggering_event,trigger_name,status
from dba_triggers
where base_object_type like 'DATABASE%'
and status like 'ENABLED%'
order by 1,2;

undefine name;
define name='trig';
@para
undefine name;