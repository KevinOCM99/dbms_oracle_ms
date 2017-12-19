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
       o.last_ddl_time
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


--3.table partitions info
prompt ****************************************************************
prompt ****************************************************************
prompt ****Table partition ...
prompt ****************************************************************
prompt ****************************************************************
COLUMN partition_name LIKE fmt_short
COLUMN PARTITION_POSITION for 99 heading PART_NUM
COLUMN tablespace_name LIKE fmt_short
COLUMN num_rows FORMAT '999,999,990'
COLUMN GLOBAL_STATS for a10 heading GLOBAL
COLUMN USER_STATS for a10 heading USER
select partition_name,PARTITION_POSITION,tablespace_name,GLOBAL_STATS,USER_STATS,num_rows
from dba_tab_partitions
WHERE  table_owner = UPPER('&schema_name')
and table_name = UPPER('&table_name')
order by PARTITION_POSITION;

--4.table index

col index_name LIKE fmt_short
col column_name LIKE fmt_short
col column_position for 00 
prompt ****************************************************************
prompt ****************************************************************
prompt ****Index ...
prompt ****************************************************************
prompt ****************************************************************
break on index_name on TABLESPACE_NAME

select index_name,case partitioned when 'YES' then '|--|--|--|--|'
	    else tablespace_name
       end tablespace_name,STATUS,partitioned,last_analyzed,INDEX_TYPE
from dba_indexes
where table_name = UPPER('&table_name')
and owner = UPPER('&schema_name')
order by 2,3,1;


prompt ****************************************************************
prompt ****************************************************************
prompt ****Index size ...
prompt ****************************************************************
prompt ****************************************************************
col owner for a20
col segment_name for a30
SELECT a.owner,a.segment_name,sum(bytes)/1024/1024 INDEX_SIZE_MB
FROM DBA_SEGMENTS a, dba_indexes b
WHERE (a.SEGMENT_TYPE = 'INDEX' or SEGMENT_TYPE = 'INDEX PARTITION')
and a.segment_name= b.index_name
and a.owner = b.owner 
and b.table_name = UPPER('&table_name')
and b.owner = UPPER('&schema_name')
group by a.owner,rollup(a.segment_name)
order by 1,2;


prompt ****************************************************************
prompt ****************************************************************
prompt ****Index Partition...
prompt ****************************************************************
prompt ****************************************************************
CLEAR COMPUTES
CLEAR BREAKS
COLUMN partition_name LIKE fmt_short
COLUMN PARTITION_POSITION for 99 heading PART_NUM
COLUMN tablespace_name LIKE fmt_short
COLUMN num_rows FORMAT '999,999,990'
break on index_name on partition_name
select index_name,partition_name,PARTITION_POSITION,tablespace_name,status,num_rows
from dba_ind_partitions
WHERE  INDEX_OWNER = UPPER('&schema_name')
and index_name in (
	select index_name
	from dba_indexes
	where table_name = UPPER('&table_name')
	and owner = UPPER('&schema_name')
	)
order by index_name,PARTITION_POSITION;
    
prompt ****************************************************************
prompt ****************************************************************     
prompt ****Indexes detailed information ...
prompt ****************************************************************
prompt ****************************************************************
CLEAR COMPUTES
CLEAR BREAKS
break on index_name
select index_name,column_name,column_position
from dba_ind_columns
where index_owner=UPPER('&schema_name')
and index_name in (
	select index_name
	from dba_indexes
	where table_name = UPPER('&table_name')
	and owner = UPPER('&schema_name')
	)
order by 1,3,2;	
----get table info by owner end