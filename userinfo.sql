---------------------------------------------
-- Query Usage  : @userinfo                --
-- Purpose      : Query account basic info --
-- DBMS Version : 11g		           --
-- Update Date  : 20140108	initial	   --
--		  20141023      profile	   --
---------------------------------------------
set verify off
set lines 999
undefine user_in_Cap
accept user_in_Cap CHAR prompt           'Please provide user or userlist (user1,user2): '
declare 
 userXXnameList varchar2(1000) := upper('&&user_in_Cap'); 
 thisuser varchar2(30);
 no_grant exception;
 pragma exception_init( no_grant, -31608 ); 
 schema_size varchar2(100);
 default_profile varchar2(200);
 userseq number;
begin
 userXXnameList := trim(userXXnameList);
 userseq := 0;
 while length (userXXnameList) > 0 and userXXnameList != ',' loop
   begin
     if instr(userXXnameList,',') > 0 then
         thisuser := substr(userXXnameList,1,instr(userXXnameList,',') - 1);
         thisuser := trim(thisuser);
         userXXnameList := substr(userXXnameList,instr(userXXnameList,',') + 1, length(userXXnameList) - instr(userXXnameList,',') + 1);
         userXXnameList := trim(userXXnameList);
     else
         thisuser := userXXnameList;
         userXXnameList := '';
     end if;
     if thisuser = ',' then 
        continue;
     end if;
     userseq := userseq + 1;
     --
     --output
     dbms_output.put_line('--**************************************************************');
     dbms_output.put_line('-- No.'||to_char(userseq)||' Account Name : ' || thisuser || ' --------- Begin ---------');
     dbms_output.put_line('--**************************************************************');
         
     dbms_output.put_line('---------------------------');
     dbms_output.put_line(dbms_metadata.get_ddl('USER',thisuser));
     dbms_output.put_line('/');
     dbms_output.put_line(chr(10));
     begin
       dbms_output.put_line('-------------system--------------');
       dbms_output.put_line(replace(dbms_metadata.get_granted_ddl('SYSTEM_GRANT',thisuser),chr(10),chr(10)||'  /'||chr(10)));
       dbms_output.put_line('/');
       dbms_output.put_line(chr(10));
     exception
       when no_grant then dbms_output.put_line('-- No system privs granted');
       dbms_output.put_line(chr(10));
     end;

     begin
       dbms_output.put_line('-------------role--------------');
       dbms_output.put_line(replace(dbms_metadata.get_granted_ddl('ROLE_GRANT',thisuser),chr(10),chr(10)||'  /'||chr(10)));
       dbms_output.put_line('/' || chr(10));
     exception
       when no_grant then dbms_output.put_line('-- No role privs granted');
       dbms_output.put_line(chr(10));
     end;

     select 'ALTER USER ' || thisuser || ' profile ' || PROFILE || ';' into default_profile
     FROM dba_users
     where username= thisuser ;
     dbms_output.put_line('---------------------------');
     dbms_output.put_line(chr(10));
     dbms_output.put_line('--' || upper('Profile : '));
     dbms_output.put_line(default_profile);
     dbms_output.put_line('--');


     select sum(bytes)/1024/1024 MB into schema_size
     FROM dba_segments
     where owner= thisuser ;

     dbms_output.put_line('---------------------------');
     dbms_output.put_line(chr(10));
     dbms_output.put_line('--' || upper('Schema space size (MB): '));
     dbms_output.put_line('--' || schema_size);
     dbms_output.put_line('--');
     dbms_output.put_line('--');
     dbms_output.put_line('--**************************************************************');
     dbms_output.put_line('-- No.'||to_char(userseq)||' Account Name : ' || thisuser || ' --------- End ---------');
     dbms_output.put_line('--**************************************************************');
     dbms_output.put_line('--');
     dbms_output.put_line('--');
     dbms_output.put_line('--');
     exception
     when others then
      if SQLCODE = -31603 then 
        dbms_output.put_line('-- User does not exists');
        dbms_output.put_line('--');
        dbms_output.put_line('--');
        dbms_output.put_line('--**************************************************************');
        dbms_output.put_line('-- No.'||to_char(userseq)||' Account Name : ' || thisuser || ' --------- End ---------');
        dbms_output.put_line('--**************************************************************');
        dbms_output.put_line('--');
        dbms_output.put_line('--');
        dbms_output.put_line('--');
      else raise;
      end if;
   end;
 end loop;
end;
/