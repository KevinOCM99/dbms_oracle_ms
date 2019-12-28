set lines 180
set pages 999
col file# for 999
col file_name for a50
col CHECKPOINT_CHANGE# for 999999999999
col last_change# for 999999999999
with
simple_path as (select substr(name,1,instr(name,'/',-1)) path_kk from v$datafile where file#=1)
select a.file#
, replace(a.name,d.path_kk,'') file_name
, c.current_scn as curr_scn
, c.checkpoint_change# as ckpt_scn
, case when c.checkpoint_change# > a.checkpoint_change# then '>'
	   when c.checkpoint_change# = a.checkpoint_change# then '='
	   else '<'
  end as s1
, a.checkpoint_change# as df_scn_in_ctrl
, case when a.checkpoint_change# > b.checkpoint_change# then '>'
	   when a.checkpoint_change# = b.checkpoint_change# then '='
	   else '<'
  end as s2
, b.checkpoint_change# as start_scn
, a.last_change# as stop_scn
from v$datafile a, v$datafile_header b, v$database c, simple_path d
where a.file# = b.file#
order by 2;
