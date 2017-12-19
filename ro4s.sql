whenever sqlerror exit rollback
set feed on
set head on
set arraysize 1
set space 1
set verify off
set pages 100
set lines 120
set termout on
set serveroutput on size 1000000
undefine source_schema
undefine target_schema
accept source_schema varchar2 prompt           'source schema: '  
accept target_schema varchar2 prompt           'target schema: ' 
declare
	tmp_source_schema varchar2(50);
	tmp_target_schema varchar2(50);
BEGIN
 tmp_source_schema := upper('&&source_schema');
 tmp_target_schema := upper('&&target_schema');
 dbms_output.put_line('-------------------grant begin-----------------');
 FOR i IN (SELECT object_name,object_type FROM dba_objects WHERE owner = tmp_source_schema and object_type in ('PROCEDURE','PACKAGE','FUNCTION','TYPE') order by object_type,object_name)
 LOOP
 dbms_output.put_line('--' || i.object_type);
 dbms_output.put_line('GRANT EXECUTE ON ' || tmp_source_schema || '.' ||i.object_name||' TO ' || tmp_target_schema || ';' );
 END LOOP;

 FOR j IN (SELECT object_name,object_type FROM dba_objects WHERE owner = tmp_source_schema and object_type in ('TABLE','VIEW','SEQUENCE','MATERIALIZED VIEW') order by object_type,object_name)
 LOOP
 dbms_output.put_line('--' || j.object_type);
 dbms_output.put_line('GRANT SELECT ON ' || tmp_source_schema || '.' ||j.object_name||' TO ' || tmp_target_schema || ';');
 END LOOP;
 dbms_output.put_line('-------------------grant end-----------------');
END;
/ 
