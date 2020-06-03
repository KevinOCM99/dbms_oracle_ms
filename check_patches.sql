-- -----------------------------------------------------------------------------------
-- File Name    : https://MikeDietrichDE.com/wp-content/scripts/12c/check_patches.sql
-- Author       : Mike Dietrich (2nd query borrowed from Tim Hall)
-- Description  : Displays contents of the patches (BP/PSU) registry and history
-- Requirements : Access to the DBA role.
-- Call Syntax  : @check_patches.sql
-- Last Modified: 23/05/2017
-- -----------------------------------------------------------------------------------

SET LINESIZE 500
SET PAGESIZE 1000
SET SERVEROUT ON
SET LONG 2000000

COLUMN action_time FORMAT A20
COLUMN action FORMAT A10
COLUMN bundle_series FORMAT A10
COLUMN comments FORMAT A30
COLUMN description FORMAT A40
COLUMN namespace FORMAT A20
COLUMN status FORMAT A10
COLUMN version FORMAT A10


SELECT TO_CHAR(action_time, 'YYYY-MM-DD HH24:MI:SS') AS action_time,
       action,
       namespace,
       version,
       id,
       comments,
       bundle_series
FROM   sys.registry$history
ORDER by action_time;

--
col status for a10
col action for a10
col action_time for a30
col description for a60
select patch_id,patch_type,action,status,action_time,description from dba_registry_sqlpatch order by action_time;

