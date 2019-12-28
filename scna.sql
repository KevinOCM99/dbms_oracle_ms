set lines 180
set pages 999
col file# for 999
col file_name for a50
col CHECKPOINT_CHANGE# for 999999999999
col last_change# for 999999999999
select a.file#
, replace(a.name,substr(e.name,1,instr(e.name,'/',-1)),'') file_name
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
from v$datafile a, v$datafile_header b, v$database c, v$datafile e
where a.file# = b.file# and e.file#=1
order by 2;

