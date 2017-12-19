--------------------------------------------------------------
-- Paraneter : ORACLE_SID/ORACLE_BASE/ORACLE_HOME           --
-- Name      : get_env.sql                                  --
-- Base      : DBMS_SYSTEM.GET_ENV()                        --
-- Created   : 2015-03-25                                   --
--------------------------------------------------------------

undefine ENVAR
--accept ENVAR prompt "OS Environment Variable: "
--define ENVAR='ORACLE_HOME'
define ENVAR='&1'

set serveroutput on feedback off

declare
    buffer varchar2(300);
begin
    dbms_system.get_env('&ENVAR', BUFFER);
    dbms_output.put_line(BUFFER);
end;
/

undefine ENVAR
set serveroutput off feedback on

---------
-- EOF --
---------
