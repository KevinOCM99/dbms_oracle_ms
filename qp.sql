set line 200 pages 999 
select * from table(dbms_xplan.display_cursor('&1',null,'advanced'));
