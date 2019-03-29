col comp_name for a30;
col status for a20;
col version for a10;
select comp_name, status, substr(version,1,10) as version from dba_registry where comp_id = 'CONTEXT';


