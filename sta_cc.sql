-- -----------------------------------------------------------------------------------
-- File Name    : https://MikeDietrichDE.com/wp-content/scripts/
-- Author       : Mike Dietrich
-- Description  : Run SQL Tuning Advisor on a SQL Tuning Set
-- Requirements : Access to the DBA role.
-- Call Syntax  : @sta_ccr.sql
-- Last Modified: 09/05/2019
-- -----------------------------------------------------------------------------------

SET SERVEROUT ON
SET PAGESIZE 1000
SET LONG 2000000
SET LONGCHUNKSIZE 100000
SET LINESIZE 10000
SET PAGESIZE 10000


DECLARE

  sts_task   VARCHAR2(64);
  tname      VARCHAR2(100);
  sta_exists number;

BEGIN

  SELECT count(*)
  INTO   sta_exists
  FROM   DBA_ADVISOR_TASKS
  WHERE  rownum = 1 AND
         task_name = 'STA_UPGRADE_TO_19C_CC';

  IF sta_exists = 1 THEN
    SYS.DBMS_SQLTUNE.DROP_TUNING_TASK(
       task_name=>'STA_UPGRADE_TO_19C_CC'
       );
  ELSE
    DBMS_OUTPUT.PUT_LINE('SQL Tuning Task does not exist - will be created ...');
  END IF;

--
-- Create a STA Task and parameterize it
--


  tname := DBMS_SQLTUNE.CREATE_TUNING_TASK(
        sqlset_name  => 'STS_CaptureCursorCache', 
        rank1        => 'BUFFER_GETS',
        time_limit   => 360,
        task_name    => 'STA_UPGRADE_TO_19C_CC',
        description  => 'Tune AWR Workload for upgrade to 19c');



--
-- Simulate execution of STS in 19c
--

  DBMS_SQLTUNE.EXECUTE_TUNING_TASK( 
     task_name      => 'STA_UPGRADE_TO_19C_CC');

END;
/

--
-- Just in case you'd like to monitor the progress of a task
--
-- SELECT sofar, totalwork FROM V$ADVISOR_PROGRESS WHERE task_id = (SELECT task_id FROM USER_ADVISOR_TASKS WHERE task_name='STA_UPGRADE_TO_19C_CC');
--

SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK(task_name=>'STA_UPGRADE_TO_19C_CC', section=>'FINDINGS', result_limit => 20) FROM DUAL;

SELECT DBMS_SQLTUNE.SCRIPT_TUNING_TASK(task_name=>'STA_UPGRADE_TO_19C_CC', rec_type=>'ALL') FROM DUAL;
