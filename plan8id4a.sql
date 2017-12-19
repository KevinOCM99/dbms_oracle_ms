set serveroutput off
undefine sql_id
SELECT * FROM table(dbms_xplan.display_cursor('&sql_id', NULL, 'all'));
