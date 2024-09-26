alter session set NLS_LANGUAGE='ENGLISH';
alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD"T"HH24:MI:SS.FF';
alter session set NLS_TIMESTAMP_TZ_FORMAT='YYYY-MM-DD"T"HH24:MI:SS.FF TZR';

set lines 150 pages 999;
col comp_id for a15;
col COMP_NAME for a45;
col action_time for a30;
col comments for a45;
col action for a10;
col version for a30;
col BUNDLE_SERIES for a5 heading BS;
col status for a15;
col version_full for a15;
col source_version for a15;
col target_version for a15;

SELECT comp_id, comp_name, version, status ,version_full 
FROM dba_registry
order by 1;

select action_time, action, version, comments
from dba_registry_history
order by 1 desc;


select patch_id,patch_type,action,status,action_time,source_version,target_version from dba_registry_sqlpatch;


