clear breaks;
clear columns;
set lines 150;
col username for a30;
col account_status for a15;
col expiry_date for a20;
col created for a20;
col profile for a20;
select username,account_status,to_char(expiry_date,'yyyy-mm-dd hh24:mi:ss') expiry_date,profile,created
from dba_users
where username like upper('%&name%')
and account_status ='OPEN'
order by 1;