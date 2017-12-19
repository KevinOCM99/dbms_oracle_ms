-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/host_aces.sql
-- Author       : Tim Hall
-- Description  : Displays information about host ACEs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @host_aces
-- Last Modified: 10/09/2014
-- -----------------------------------------------------------------------------------
SET LINESIZE 120

COLUMN host FORMAT A30
COLUMN start_date FORMAT A11
COLUMN end_date FORMAT A11
col principal for a15
col principal_type heading PType for a10
col lower_port heading LPort for 99999
col upper_port heading UPort for 99999
col grant_type for a10
col privilege for a15


SELECT host,
       lower_port,
       upper_port,
       ace_order,
       grant_type,
--       inverted_principal,
       principal,
       principal_type,
       privilege
FROM   dba_host_aces
ORDER BY host, ace_order;