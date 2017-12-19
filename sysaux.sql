set echo off
----------------------------------------------------------------------------------------------------
-- Script Name : sysaux_occupants.sql                                                             --
-- Parameter   : none                                                                             --
-- Birthday    : 2015-05-15 Sunny Friday                                                          --
-- Revision    : 1.0 on 2015-05-15                                                                --
-- Dictionary  : V$SYSAUX_OCCUPANTS                                                               --
-- ---------------------------------------------------------------------------------------------- --
-- Name                 Null?  12c Type      11g Type                                             --
-- -------------------- ------ ------------- -------------                                        --
-- OCCUPANT_NAME               VARCHAR2(64)  VARCHAR2(64)                                         --
-- OCCUPANT_DESC               VARCHAR2(64)  VARCHAR2(64)                                         --
-- SCHEMA_NAME                 VARCHAR2(64)  VARCHAR2(64)                                         --
-- MOVE_PROCEDURE              VARCHAR2(64)  VARCHAR2(64)                                         --
-- MOVE_PROCEDURE_DESC         VARCHAR2(64)  VARCHAR2(64)                                         --
-- SPACE_USAGE_KBYTES          NUMBER        NUMBER                                               --
-- CON_ID                      NUMBER        n/a                                                  --
----------------------------------------------------------------------------------------------------
set linesize 200 pagesize 99 termout on heading on feedback off newpage none

-----------
-- TITLE --
-----------
prompt ............................................
prompt > V$SYSAUX_OCCUPANTS WHERE SPACE_USAGE>9MB <
prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

------------
-- COLUMN --
------------
column schema_name         format a11 heading "Schema Name"
column occupant_name       format a20 heading "Occupant Name"
column move_procedure      format a36 heading "Move Procedure"
--column move_procedure_desc format a40 heading "Move Procedure Description"
column space_usage         format a11 heading "Space Usage"
column occupant_desc       format a55 heading "Occupant Description"

----------
-- BODY --
----------
select schema_name
     , occupant_name
     , lpad(round(space_usage_kbytes/1024),8,' ')||' MB' as space_usage
     , occupant_desc
     , move_procedure
     , move_procedure_desc
  from v$sysaux_occupants
 --where move_procedure is null
 where 1=1
   and round(space_usage_kbytes/1024)>9
 order by space_usage_kbytes desc,occupant_name
/

--------------
-- TEARDOWN --
--------------
set feedback on newpage 1

prompt
---------
-- EOF --
---------
