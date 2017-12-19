set lines 120 pages 999
col sql for a120
select 'drop ' 
     ||replace(object_type,'BODY','')
     ||' DVSYS.'
     ||object_name
     ||'; '
 as sql
from user_objects
where instr('FUNCTION | PROCEDURE | PACKAGE | TRIGGER | VIEW  | TYPE | DIMENSION | JAVA SOURCE | JAVA CLASS | MATERIALIZED VIEW',object_type) > 0 
order by object_type,object_name;
