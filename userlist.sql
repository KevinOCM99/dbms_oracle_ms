clear breaks;
clear columns;
col username for a25;
col account_status for a20;
col expiry_date for a20;
col create_date for a20;
col profile for a30;
select username,account_status,to_char(created,'yyyy-mm-dd hh24:mi:ss') create_date,to_char(expiry_date,'yyyy-mm-dd hh24:mi:ss') expiry_date,profile
from dba_users
where username like upper('%&name%')
order by 1;