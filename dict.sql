---------------------------------------------
-- Query Usage  : @dict                    --
-- Purpose      : Query on Data Dictionary --
-- DBMS Version : 11.2.0.3.0               --
-- Update Date  : 20131212-20140104        --
---------------------------------------------
set linesize 180 pagesize 80 heading on feedback 1 verify off
column table_name format a32 heading "DBA View"
column comments   format a99 heading "Comments"
accept dd_nm prompt "Enter Keyword to Search in Data Dictionary: "
with a as (
select table_name as org_name
     , decode(substr(table_name,1,3),'GV$',substr(table_name,2,length(table_name)),table_name) as tmp_name
     , comments
  from dict
where table_name like upper('%&dd_nm%')
   and table_name not like 'ALL_%'
   and table_name not like 'USER_%'
),   b as (
select decode(tmp_name
             ,lag(tmp_name,1,null)over(order by tmp_name,org_name)
             ,'G)'||tmp_name
             ,tmp_name) as table_name
     , org_name
     , comments
  from a
)
select table_name
     , comments
  from b
where org_name not like 'GV$%'
order by table_name
/
