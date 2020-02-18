-- -----------------------------------------------------------------------------------
-- File Name    : https://MikeDietrichDE.com/wp-content/scripts/12c/check_patches.sql
-- Author       : Mike Dietrich
-- Description  : Capture SQL Statements from Cursor Cache into a SQL Tuning Set
-- Requirements : Access to the DBA role.
-- Call Syntax  : @capture_cc.sql
-- Last Modified: 29/05/2017
-- -----------------------------------------------------------------------------------

SET SERVEROUT ON
SET PAGESIZE 1000
SET LONG 2000000
SET LINESIZE 400

--
-- Drop the SQL Tuning SET if it exists
--

DECLARE

  sts_exists number;
  stmt_count number;

BEGIN

  SELECT count(*)
  INTO   sts_exists
  FROM   DBA_SQLSET
  WHERE  rownum = 1 AND
         name = 'STS_CaptureCursorCache';

  IF sts_exists = 1 THEN
    SYS.DBMS_SQLTUNE.DROP_SQLSET(
       sqlset_name=>'STS_CaptureCursorCache'
       );
  ELSE
    DBMS_OUTPUT.PUT_LINE('SQL Tuning Set does not exist - will be created ...');
  END IF;


--
-- Create a SQL Tuning SET 'STS_CaptureCursorCache'
--

  SYS.DBMS_SQLTUNE.CREATE_SQLSET(
     sqlset_name=>'STS_CaptureCursorCache',
     description=>'Statements from Before-Change'
     );


--
-- Poll the Cursor Cache
-- time_limit: The total amount of time, in seconds, to execute
-- repeat_interval: The amount of time, in seconds, to pause between sampling
-- Adjust both settings based on needs
--

 DBMS_OUTPUT.PUT_LINE('Now polling the cursor cache for 240 seconds every 10 seconds ...');
 DBMS_OUTPUT.PUT_LINE('You will get back control in 4 minutes.');
 DBMS_OUTPUT.PUT_LINE('.');

 DBMS_SQLTUNE.CAPTURE_CURSOR_CACHE_SQLSET(
        sqlset_name => 'STS_CaptureCursorCache',
        time_limit => 240,
        repeat_interval => 10,
        capture_option => 'MERGE',
        capture_mode => DBMS_SQLTUNE.MODE_ACCUMULATE_STATS,
        basic_filter => 'parsing_schema_name not in (''DBSNMP'',''SYS'',''ORACLE_OCM'',''LBACSYS'',''XDB'',''WMSYS'')',
        sqlset_owner => NULL,
        recursive_sql => 'HAS_RECURSIVE_SQL');

--
-- Display the amount of statements collected in the STS
--

SELECT statement_count
INTO stmt_count
FROM dba_sqlset
WHERE name = 'STS_CaptureCursorCache';

DBMS_OUTPUT.PUT_LINE('There are now ' || stmt_count || ' SQL Statements in this STS.');

--
-- If you need more details please use:
--
--    SELECT sql_text,cpu_time,elapsed_time, executions, buffer_gets
--      FROM dba_sqlset_statements
--      WHERE sqlset_name='STS_CaptureCursorCache';
--

END;
/

