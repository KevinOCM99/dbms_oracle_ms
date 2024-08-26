set lines 200 pages 999;

select * from table(dbms_xplan.display_cursor(null,null,'ALL ALLSTATS LAST +cost'));
