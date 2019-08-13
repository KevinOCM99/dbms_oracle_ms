--get table info by owner begin
--table info
prompt ADSA_OWNER
prompt SG_ALL_ASSET_FACT
ACCEPT table_name prompt 'Enter Table Name: ' 

alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';


--1.table definition
prompt ****************************************************************
prompt ****************************************************************
prompt ****Column definition ...   
prompt ****************************************************************
prompt ****************************************************************
CLEAR COMPUTES
CLEAR BREAKS
--BREAK ON DATA_TYPE
COLUMN fmt_short    FORMAT A28
col table_name LIKE fmt_short
col status for a15
col LAST_ANALYZED for a20
col partitioned for a10
col tablespace_name like fmt_short
SELECT 
TABLE_NAME,
STATUS,
LAST_ANALYZED,
PARTITIONED,
TABLESPACE_NAME
FROM  user_tables 
WHERE table_name like UPPER('&table_name%')
order by 1;
