clear breaks;
clear columns;
col username for a25;
col account_status for a20;
col expiry_date for a20;
col profile for a30;
col password_version for a20;
col authentication_type for a10 heading AUTH_TYPE;
select username,account_status,to_char(expiry_date,'yyyy-mm-dd hh24:mi:ss') expiry_date,profile,password_versions,authentication_type
from dba_users
where username like upper('%&name%')
and account_status ='OPEN'
order by 1;
