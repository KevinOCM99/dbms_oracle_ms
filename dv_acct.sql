select unique GRANTEE from dba_role_privs
where GRANTED_ROLE in ('DV_ACCTMGR','DV_OWNER')
and grantee <> 'DVSYS';
