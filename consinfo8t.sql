-----------------------------------------------------------------------------------------
-- Known  : Table Owner & Table Name                                                   --
-- Name   : cons.sql (V1)                                                              --
-- Use    : Get Table Constraint Information                                           --
-- View   : dba_Constraints                                                            --
-- Apply2 : 11g                                                                        --
-- Create : 20140909                                                                   --
-- Update : 20140909                                                                   --
-----------------------------------------------------------------------------------------


undefine cons_owner
undefine cons_name
accept cons_owner char prompt           'cons_owner : ' 
accept tab_name char prompt           'tab_name : ' 


clear columns breaks computes
set linesize 200 pagesize 100 wrap on
column owner             format a15 heading "Table|Owner"
column table_name        format a15 heading "Table|Name"
column constraint_name   format a20 heading "Constraint|Name"
column constraint_type   format a01 heading "C|T"
column valid             format a05 heading "Cons|Valid"
column status            format a08 heading "Enforce|Status"
column validated         format a09 heading "Data|Validated"
column deferrable        format a05 heading "Defer|rable"
column deferred          format a05 heading "Defer|red"
column generated         format a04 heading "Name|By"
column bad               format a03 heading "Bad"
column rely              format a04 heading "Rely"
column bad_rely          format a04 heading "Bad|Rely"
column last_change       format a19 heading "Last|Change"
column view_related      format a04 heading "View|Dep"
column R_OWNER 		 format a10
column delete_rule  for a6 heading  "Delete|Rule"  
column index_owner  for a15	
-- heading   "Index|Owner"
column index_name   for a25 	
--heading    "Index|Name"
column search_condition for a80
set heading on feedback 1
set echo off

select owner
     , table_name
     , constraint_type
     , decode(invalid,'INVALID','No',null,'Yes','?')                   as valid
     , status
     , decode(validated,'NOT VALIDATED','NOT',validated)               as validated
   --, dbms_lob.substr(search_condition,4000,1) as search_condition
     , r_owner
     , r_constraint_name     
  from dba_constraints
where owner= upper('&cons_owner')
and table_name = upper('&tab_name')
order by constraint_name
/

select delete_rule
     , decode(deferrable,'DEFERRABLE','Yes','NOT DEFERRABLE','No','?') as deferrable
     , decode(deferred,'DEFERRED','Yes','IMMEDIATE','No','?')          as deferred
     , decode(generated,'USER NAME','User','GENERATED NAME','Sys','?') as generated
     , lpad(substr(bad,1,1),1,' ')||lpad(substr(rely,1,1),1,' ')       as bad_rely
     , last_change
     , decode(view_related,'DEPEND ON VIEW','Yes',null,'No','?')       as view_related
     , index_owner      
     , index_name       
  from dba_constraints
where owner= upper('&cons_owner')
and table_name = upper('&tab_name')
order by constraint_name
/

select constraint_name
     , search_condition
  from dba_constraints
where owner= upper('&cons_owner')
and table_name = upper('&tab_name')
order by constraint_name
/