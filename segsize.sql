select owner,segment_name,sum(bytes)/1024/1024 MB
from dba_extents 
where owner='&owner'
and segment_name = '&seg_name'
group by owner,segment_name;
