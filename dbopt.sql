set lines 180;
col parameter for a50
col value for a30
col con_id for 99999
select * 
from v$option 
where upper(parameter) like upper('%&db_option%')
order by 1;
undefine db_option;