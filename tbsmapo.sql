ACCEPT var_file_id prompt 'file id: ' 
CLEAR BREAKS
break on owner on segment_name on partition_name on segment_type
col block_id for 999999999
col end_block for 999999999
col owner for a20
col segment_name for a30
col partition_name for a20
col segment_type for a20
select 	&var_file_id file_id from dual;
select
	owner,
	segment_name,
	segment_type,
	partition_name,
	block_id,
	block_id + blocks - 1	end_block
from
	dba_extents
where
	file_id = &var_file_id
union all
select
	'=======FREE======>'	owner,
	'=======FREE======>'	segment_name,
	'=======FREE======>'	segment_type,
	'=======FREE======>'	partition_name,
	block_id,
	block_id + blocks - 1	end_block
from
	dba_free_space
where
	file_id = &var_file_id
order by block_id;
select 	&var_file_id file_id from dual;