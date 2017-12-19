set echo off termout on feedback off newpage none
----------------------------------------------------------------------------------------------------
-- Script    : dpv/asm_client_11g.sql                                                             --
-- Category  : SELECT [ NEWPAGE=NONE and NO-PROMPT by Default ]                                   --
-- Dictionay : V$BLOCK_CHANGE_TRACKING                                                            --
-- Parameter : none                                                                               --
-- Location  : DBA\Grid_Computing\ASM\Dictionary                                                  --
-- Birthday  : 2015-04-22                                                                         --
-- Revision  : 2015-04-22                                                                         --
----------------------------------------------------------------------------------------------------

--  Name               Null? 11.2.0.3.0
--  ------------------ ----- ------------
--  GROUP_NUMBER             NUMBER
--  INSTANCE_NAME            VARCHAR2(64)
--  DB_NAME                  VARCHAR2(10)
--  STATUS                   VARCHAR2(12)
--  SOFTWARE_VERSION         VARCHAR2(60)
--  COMPATIBLE_VERSION       VARCHAR2(60)

ttitle off

column asm_inst_id        format a15 heading "ASM|Instance|Name"
column db_name            format a08 heading "Client|DB|Name"
column instance_name      format a15 heading "Client|Instance|Name"
column status             format a12 heading "Client|Connection|Status"
column software_version   format a12 heading "Client|Software|Version"
column compatible_version format a12 heading "Client|Compatible|Version"
column dg_name_list       format a25 heading "ASM|DiskGroup|List"

break on db_name skip 1

prompt ....................    ...............
prompt > GV$ASM_DISKGROUP <    > DB-ORIENTED <
prompt ^^^^^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^

select distinct
       cl.db_name
     , cl.instance_name
     , cl.software_version
     , cl.compatible_version
     , cl.status
     , it.inst_id||')'||it.instance_name as asm_inst_id
     , listagg(dg.group_number||')'||dg.name,';') within group (order by cl.group_number)
                                    over (partition by cl.inst_id,cl.db_name,cl.instance_name) as dg_name_list
  from gv$asm_client cl
  left outer
  join v$asm_diskgroup dg
    on cl.group_number = dg.group_number
  left outer
  join gv$instance it
    on cl.inst_id = it.inst_id
 order by cl.db_name,cl.instance_name,it.inst_id||')'||it.instance_name
/

clear breaks
column asm_dg_name        format a12 heading "ASM|DiskGroup|Name"
break on asm_inst_id skip 1 on asm_dg_name

prompt ....................    ................
prompt > GV$ASM_DISKGROUP <    > ASM-ORIENTED <
prompt ^^^^^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^

select distinct
       it.inst_id||')'||it.instance_name as asm_inst_id
     , dg.group_number||')'||dg.name     as asm_dg_name
     , cl.status
     , cl.db_name
     , cl.instance_name
     , cl.software_version
     , cl.compatible_version
  from gv$asm_client cl
  left outer
  join v$asm_diskgroup dg
    on cl.group_number = dg.group_number
  left outer
  join gv$instance it
    on cl.inst_id = it.inst_id
 order by asm_inst_id, asm_dg_name, cl.db_name, cl.instance_name
/

--------------
-- TEARDOWN --
--------------
set feedback on newpage 1

---------
-- EOF --
---------
