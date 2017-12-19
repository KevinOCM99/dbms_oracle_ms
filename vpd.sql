col object_name for a30
col policy_group  for a20
col policy_name  for a30
col pf_owner for a20
col package for a20
col function for a20
select object_name,policy_group,policy_name,pf_owner,package,function
from dba_policies
where object_owner = 'AVSYS'
order by object_name;