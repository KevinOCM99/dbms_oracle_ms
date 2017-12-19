col spid for 999999
col pname for a15
col username for a15
column background heading "BGP"
col ADDR for a30
select addr,spid,pname,username,background
from v$process
where addr like '&paddr%'
order by pname;