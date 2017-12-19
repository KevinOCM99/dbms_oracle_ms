col index_name LIKE fmt_short
col column_name LIKE fmt_short
col column_position for 00 
prompt ****************************************************************
prompt ****************************************************************
prompt ****Index ...
prompt ****************************************************************
prompt ****************************************************************
CLEAR COMPUTES
CLEAR BREAKS
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
SELECT a.owner,a.segment_name,sum(bytes)/1024/1024 MB
FROM DBA_SEGMENTS a, dba_indexes b
WHERE (a.SEGMENT_TYPE = 'INDEX' or SEGMENT_TYPE = 'INDEX PARTITION')
and a.segment_name= b.index_name
and a.owner = b.owner 
and b.table_name = UPPER('&table_name')
and b.owner = UPPER('&schema_name')
group by a.owner,a.segment_name
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