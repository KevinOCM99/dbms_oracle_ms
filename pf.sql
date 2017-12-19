clear columns
column resource_name  format a25 heading "Resource_Name"
column resource_type  format a13 heading "Resource_Type"
column profile        format a30 heading "Profile_Name"
column limit          format a20 heading "Limit_Value"

clear breaks computes
break on profile skip 1

select '[DEFAULT]' as profile
     , resource_type
     , resource_name
     , limit
  from dba_profiles
 where profile = 'DEFAULT'
 union all
select a.profile
     , a.resource_type
     , a.resource_name
     , a.limit
  from dba_profiles a
     , dba_profiles b
 where a.profile <> 'DEFAULT'
   and a.limit   <> 'DEFAULT'
   and b.profile =  'DEFAULT'
   and 7=7
   and a.resource_type =  b.resource_type
   and a.resource_name =  b.resource_name
   and a.limit         <> b.limit
 order by profile,resource_type,resource_name
/
