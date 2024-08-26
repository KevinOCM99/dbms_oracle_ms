set lines 150;
select * from table(dbms_xplan.display());
