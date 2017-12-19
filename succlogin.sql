col HOST for a20;
col ip_address for a20;
col first_login for a20;
col last_login for a20;
col total for 999999;
col DB_USER for a30;
select DB_USER,
to_char(min(LOGIN_DATE),'YYYY/MM/DD HH24:MI:SS') first_login,
to_char(max(LOGIN_DATE),'YYYY/MM/DD HH24:MI:SS') last_login,
count(*) total
from DB_SUCCESS_LOGIN
where DB_USER not in ('DBSNMP','KEVIN','RNAYAK','SYS','PUBLIC','LIANG','ARAI','SYSTEM','VICTOR')
group by DB_USER
order by DB_USER;
