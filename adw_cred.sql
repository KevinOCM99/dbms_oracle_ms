col owner for a30;
col credential_name for a45;
col username for a30;
col enabled for a10;
select owner,credential_name,username,enabled
from dba_credentials order by 1,2;
