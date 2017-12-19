--------------------------------------------------------------------------------
-- Ask4 : none                                                                --
-- Name : role_privs.sql                                                      --
-- Todo : What privileges(role/system/table) does a role have?                --
-- View : DBA_ROLES,ROLE_ROLE_PRIVS,ROLE_SYS_PRIVS,ROLE_TAB_PRIVS             --
-- Tool : login.sql; co_fo.sql                                                --
-- Base : 11g                                                                 --
-- Born : 20150306                                                            --
-- Fix1 : 20150306                                                            --
-- Path : FIL-DBA/Basics/User                                                 --
--------------------------------------------------------------------------------

------------------------
-- Make a GO-DECISION --
------------------------
set newpage  none
set heading  off
set feedback off
set long 999 longchunksize 999


select cnt||' profiles found in this database.'
  from (select count(distinct profile) as cnt from dba_profiles)
;

set newpage  none
set heading  on
set feedback on

@@aux_pause


--------------------------
-- Construct Pivot List --
--------------------------
set linesize 999 pagesize 99 heading off feedback off newpage none wrap off
set longchunksize 999
column namelist new_value n_list noprint format a999

select '''DEFAULT'' as default_limit,'||wm_concat(''''||profile||''' as '||profile||'_limit') namelist
  from (select distinct profile from dba_profiles where profile <> 'DEFAULT')
connect by nocycle profile = prior profile
order SIBLINGS by profile
;

set linesize 180 pagesize 40 heading on feedback on newpage none wrap on
--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--


clear columns breaks computes
column resource_name          format a25 heading "Resource|Name"
column resource_type          format a13 heading "Resource|Type"
column profile                format a30 heading "Profile|Name"
column default_limit          format a20 heading "'DEFAULT'|Limit"

-----------------------------------------------------------------------------------------
-- COLUMN SCRIPT --                                                                     <
-- column fil_app_profile_limit  format a20 heading "'FIL_APP_PROFILE'|Limit"           <
-- column fil_dba_profile_limit  format a20 heading "'FIL_DBA_PROFILE'|Limit"           <
-- column fil_usr_profile_limit  format a20 heading "'FIL_USR_PROFILE'|Limit"           <
----------------------------------------------------------------------------------------<
set newpage none
set termout  off
set verify   off
set heading  off
set feedback off
set pause    off
set echo     off

spool x.sql
select 'column '||profile||'_limit format a20 heading "'''||profile||'''|Limit"'
  from (select distinct profile from dba_profiles where profile <> 'DEFAULT')
where profile <> 'DEFAULT'
;
spool off

@x

set termout on
set newpage 1
set heading  on
set feedback on
--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--^-^--
set newpage none

with tmp as (
select profile
     , resource_type
     , resource_name
     , limit
  from dba_profiles
)
select *
  from tmp
pivot (max(limit)for profile in (&n_list))
order by resource_type, resource_name
/

set newpage 1

---------
---EOF---
---------
