col DB_USER for a20;
col HOST for a20;
col ip_address for a15;
col first_login for a20;
col last_login for a20;
col total for 999999;
select DB_USER,HOST,ip_address,min(LOGIN_DATE) first_login,max(LOGIN_DATE) last_login, count(*) CNT
from DB_SUCCESS_LOGIN
where DB_USER like upper('&user%')
group by DB_USER,HOST,ip_address
order by 1,2;
