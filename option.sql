select banner from sys.v_$version;

col PARAMETER format a60
col VALUE format a10
select * from sys.v_$option
order by 1;
