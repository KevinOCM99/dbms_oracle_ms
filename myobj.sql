col object_name for a30;
col object_type for a30;
select object_name,object_type
from user_objects
order by 1,2;