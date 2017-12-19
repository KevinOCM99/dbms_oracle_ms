select userenv('language')
from dual; 

select distinct client_charset
from v$session_connect_info
where sid in (
select distinct sid from v$mystat
);

col parameter for a30
col value for a40
select parameter, value 
from nls_session_parameters 
order by 1;
