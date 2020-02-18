DEF spb_script = 'spb_drop';
----------------------------------------------------------------------------------------
--
-- File name:   spb_drop.sql
--
-- Purpose:     Drop one or all SQL Plan Baselines for given SQL_ID
--
-- Author:      Carlos Sierra
--
-- Version:     2018/05/13
--
-- Usage:       Connecting into PDB.
--
--              Enter SQL_ID when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @spb_drop.sql
--
-- Notes:       Accesses AWR data thus you must have an Oracle Diagnostics Pack License.
--
--              Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@spb_internal_begin.sql
--
---------------------------------------------------------------------------------------
--
@@spb_internal_plans_perf.sql
--
---------------------------------------------------------------------------------------
--
PRO
PRO BASELINES SUMMARY
PRO ~~~~~~~~~~~~~~~~~
@@spb_internal_list.sql
--
---------------------------------------------------------------------------------------
--
PRO
PRO 2. Enter PLAN_NAME (optional)
DEF plan_name = '&2.';
PRO
--
DECLARE
  l_plans INTEGER;
BEGIN
  FOR i IN (SELECT sql_handle, signature, plan_name 
              FROM dba_sql_plan_baselines 
             WHERE signature = &&signature.
               AND plan_name = NVL('&&plan_name.', plan_name)
             ORDER BY signature, plan_name)
  LOOP
    l_plans := DBMS_SPM.drop_sql_plan_baseline(sql_handle => i.sql_handle, plan_name => i.plan_name);
  END LOOP;
END;
/
--
---------------------------------------------------------------------------------------
--
PRO
PRO BASELINES SUMMARY
PRO ~~~~~~~~~~~~~~~~~
@@spb_internal_list.sql
--
@@spb_internal_end.sql