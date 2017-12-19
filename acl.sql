--dba_network_acls
col acl for a30;
select host,lower_port,upper_port,aclid,acl
from dba_network_acls;

--dba_network_acl_privileges
col is_grant for a10;
col invert for a15;
col privilege for a10;
col principal for a20;
col acl for a30;
select acl,principal,privilege,is_grant,invert
from dba_network_acl_privileges;