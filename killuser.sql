select 'alter system kill session ''' || sid || ',' || serial# || ',@' || inst_id || ''' immediate; '
from gv$session
where username like upper('&1%');
undefine 1