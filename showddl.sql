set serveroutput on;
set long 10000;
set lines 120 pages 999;
col myoutput for a120

declare 
 obj_id number := &object_id; 
 obj_type varchar2(100);
 obj_owner varchar2(100);
 obj_name varchar2(100);
 r clob;
begin
     select owner,object_name,object_type
     into obj_owner,obj_name, obj_type
     from dba_objects
     where OBJECT_ID = obj_id;
     --dbms_output.put_line(obj_owner);
     --dbms_output.put_line(obj_name);
     --dbms_output.put_line(obj_type);
     dbms_output.put_line('---------------------------');
     dbms_output.put_line('set serveroutput on;');
     dbms_output.put_line('set long 20000;');
     dbms_output.put_line('set lines 120 pages 999;');
     dbms_output.put_line('col myoutput for a120;');
     dbms_output.put_line('SELECT DBMS_METADATA.GET_DDL (''' || obj_type ||  ''',''' || obj_name || ''',''' || obj_owner || ''' ) myoutput FROM DUAL;');
     dbms_output.put_line('---------------------------');
     --select DBMS_METADATA.GET_DDL(obj_type,obj_name,obj_owner)
     --into r
     --from dual;
     --dbms_output.put_line('---------------------------');
     --dbms_output.put_line(r);
     --dbms_output.put_line('---------------------------');
end;
/
