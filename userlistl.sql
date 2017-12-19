clear breaks;
clear columns;
col username for a25;
col account_status for a20;
col expiry_date for a20;
col profile for a30;
select username,account_status,to_char(expiry_date,'yyyy-mm-dd hh24:mi:ss') expiry_date,profile
from dba_users
where username like upper('%&name%')
and account_status like 'LOCKED%'
order by 1;