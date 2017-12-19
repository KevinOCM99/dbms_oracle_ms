break on tablespace_name;
col file_id for 99
col tablespace_name for a20;
col file_name for a60;
col current_MB for 99999999999
col size_bound for 99999999999
undefine tbs 
accept tbs prompt "Tablepspace Name? "
select a.*,case when b.size_bound is null then 0 else b.size_bound end size_bound
from
(select tablespace_name,file_id,file_name,bytes/1024/1024 current_size
from dba_data_files
union all
select tablespace_name,file_id,file_name,bytes/1024/1024 current_size
from dba_temp_files
) a left join 
(
select a.file_id,(block_id + blocks)*8/1024 size_bound
from dba_extents a,
(select file_id, max(block_id) max_block_id
from dba_extents
where tablespace_name like upper('&&tbs%')
group by file_id) b
where a.file_id = b.file_id 
and a.block_id = b.max_block_id
and a.tablespace_name like upper('&&tbs%')) b on a.file_id = b.file_id
where a.tablespace_name like upper('&&tbs%')
order by 1,2;

