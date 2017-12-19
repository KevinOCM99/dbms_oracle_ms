col DB_USER for a30;
col HOST for a20;
col ip_address for a20;
col first_login for a20;
col last_login for a20;
col total for 999999;
select DB_USER,HOST,ip_address,LOGIN_DATE
from DB_FAIL_LOGIN
where DB_USER like upper('&user%')
order by 1,2;
