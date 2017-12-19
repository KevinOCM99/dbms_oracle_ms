col HOST for a20;
col ip_address for a20;
col first_login for a20;
col last_login for a20;
col total for 999999;
col db_user for a20;
select HOST,ip_address,
to_char(min(LOGIN_DATE),'YYYY/MM/DD HH24:MI:SS') first_login,
to_char(max(LOGIN_DATE),'YYYY/MM/DD HH24:MI:SS') last_login,
count(*) total
from DB_FAIL_LOGIN
group by HOST,ip_address
order by HOST,ip_address;