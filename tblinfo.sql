--get table info by owner begin
--table info
prompt ADSA_OWNER
prompt SG_ALL_ASSET_FACT
ACCEPT schema_name prompt 'Enter Table Owner: ' 
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
col DATA_TYPE LIKE fmt_short
col COLUMN_NAME LIKE fmt_short
col partitioned form a5 heading PART?
col NULLABLE for a4
col COLUMN_ID for 99 heading ID
SELECT  COLUMN_ID, 
COLUMN_NAME,
DATA_TYPE,  
LAST_ANALYZED,
NULLABLE
FROM   dba_tab_columns
WHERE  owner = UPPER('&schema_name')
and table_name = UPPER('&table_name')
order by 1;

--2.table storage information
prompt ****************************************************************
prompt ****************************************************************
prompt ****Table definition ...
prompt ****************************************************************
prompt ****************************************************************
col table_name LIKE fmt_short
col tablespace_name LIKE fmt_short
col COMPRESSION for a15
col COMPRESS_FOR for a20
COLUMN num_rows     FORMAT '999,999,990'
SELECT table_name,
       case partitioned when 'YES' then '|--|--|--|--|'
	    else tablespace_name
       end tablespace_name,
       num_rows,
       blocks
FROM   dba_tables t inner join dba_objects o on t.owner=o.owner and t.table_name = o.object_name and o.object_type='TABLE'
WHERE  t.owner = UPPER('&schema_name')
and table_name = UPPER('&table_name');

SELECT t.status,
       partitioned,
       LAST_ANALYZED,
       o.last_ddl_time,
       t.COMPRESSION,
       t.COMPRESS_FOR
FROM   dba_tables t inner join dba_objects o on t.owner=o.owner and t.table_name = o.object_name and o.object_type='TABLE'
WHERE  t.owner = UPPER('&schema_name')
and table_name = UPPER('&table_name');



prompt ****************************************************************
prompt ****************************************************************
prompt ****Table size ...
prompt ****************************************************************
prompt ****************************************************************
SELECT owner,segment_name,sum(bytes)/1024/1024 MB
FROM DBA_SEGMENTS 
WHERE (SEGMENT_TYPE = 'TABLE' or SEGMENT_TYPE = 'TABLE PARTITION')
and segment_name= upper('&table_name')
and owner = UPPER('&schema_name')
group by owner,segment_name;
