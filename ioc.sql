set lines 120 pages 999
col sql for a120
select 'alter ' 
     ||replace(object_type,'BODY','')
     ||' '
     ||owner ||'."'
     ||object_name
     ||'" compile '
     ||decode(object_type,'PACKAGE BODY','BODY','')
     ||' ;' as sql
from dba_objects
where status <> 'VALID'
and instr('FUNCTION | PROCEDURE | PACKAGE | PACKAGE BODY | TRIGGER | VIEW  | TYPE | TYPE BODY | DIMENSION | JAVA SOURCE | JAVA CLASS | MATERIALIZED VIEW',object_type) > 0 
order by owner,object_type,object_name;
