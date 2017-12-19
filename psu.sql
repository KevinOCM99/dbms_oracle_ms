Script 4 Verify PSU patching
---------------------------------
-- Creation : 2015-02-06 --
---------------------------------

set linesize 200 pagesize 40
clear columns breaks computes

column action_time format a19 heading "Action_Time"
column action format a10 heading "Action"
column namespace format a10 heading "Namespace"
column version format a10 heading "Version"
column bundle_series format a20 heading "Bundle_Series"
column comments format a20 heading "Comments"
column id format 999 heading "ID"

select action_time
, action
, namespace
, bundle_series
, version
, id
, comments
from registry$history
;
