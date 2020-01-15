col banner for a30;
col BANNER_FULL for a50;
col con_id for 999
select banner,BANNER_LEGACY,BANNER_FULL,con_id
from v$version;

col DESCRIPTION for a23;
col action_time heading ACTION_TIME for a11;
select CON_ID,
TO_CHAR(action_time, 'YYYY-MM-DD') AS action_time,
PATCH_ID,
PATCH_TYPE,
ACTION,
DESCRIPTION,
SOURCE_VERSION,
TARGET_VERSION
from CDB_REGISTRY_SQLPATCH
order by CON_ID, action_time, patch_id;

