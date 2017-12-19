col service_id for 999 heading ID;
col name for a25;
col network_name for a35 heading NTW_NAME;
col creation_date for a20;
select service_id,name,network_name,creation_date
from dba_services
order by 1;
