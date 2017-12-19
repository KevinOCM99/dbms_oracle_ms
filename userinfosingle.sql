--for system privileges and role privilges
set verify off
set lines 999
undefine user_in_Cap
declare 
 username varchar2(30) := upper('&user_in_Cap'); 
 no_grant exception;
 pragma exception_init( no_grant, -31608 ); 
 schema_size varchar2(100);
begin
 dbms_metadata.set_transform_param(dbms_metadata.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);
 dbms_output.enable(1000000);
 dbms_output.put_line('---------------------------');
 dbms_output.put_line(dbms_metadata.get_ddl('USER',username));
 begin
   dbms_output.put_line('---------------------------');
   dbms_output.put_line(dbms_metadata.get_granted_ddl('SYSTEM_GRANT',username));
   dbms_output.put_line(chr(10));
 exception
   when no_grant then dbms_output.put_line('-- No system privs granted');
   dbms_output.put_line(chr(10));
 end;

 begin
   dbms_output.put_line('---------------------------');
   dbms_output.put_line(dbms_metadata.get_granted_ddl('ROLE_GRANT',username));
   dbms_output.put_line(chr(10));
 exception
   when no_grant then dbms_output.put_line('-- No role privs granted');
   dbms_output.put_line(chr(10));
 end;

 select sum(bytes)/1024/1024 MB into schema_size
 FROM dba_segments
 where owner= username ;

 dbms_output.put_line('---------------------------');
 dbms_output.put_line(chr(10));
 dbms_output.put_line(upper('Schema space size (MB): '));
 dbms_output.put_line(schema_size);

 exception
 when others then
  if SQLCODE = -31603 then 
    dbms_output.put_line('-- User does not exists');
  else raise;
  end if;
end;
/