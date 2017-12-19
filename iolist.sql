set lines 120 pages 999;
col owner for a15
col object_name for a30
col object_type for a30
break on owner;
select owner,object_type,object_name
from dba_objects
where status <> 'VALID'
order by 1,2,3;
clear break;