set lines 180;                          
col REALM_NAME for a40;
col OWNER  for a30;
col OBJECT_NAME  for a30
col OBJECT_TYPE for a30;
select *
from DVSYS.DBA_DV_REALM_OBJECT
order by 1,2,3;
