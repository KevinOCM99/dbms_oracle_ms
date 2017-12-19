select 'alter system kill session ''' || sid || ',' || serial# || ',@' || inst_id || ''' immediate; '
from gv$session
where sid in (&sid_list);