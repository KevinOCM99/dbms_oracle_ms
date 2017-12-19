col baseline_id for 9999 heading ID
col baseline_name for a30 heading BL_Name
col baseline_type for a15 heading Type
col start_snap_id for 9999999 heading Start_ID
col end_snap_id for 9999999 heading End_ID
col moving_window_size for 9999 heading W_Size
col creation_time for a20
col expiration for 999
select baseline_id,baseline_name,baseline_type,start_snap_id,end_snap_id,moving_window_size,creation_time,expiration
from dba_hist_baseline
order by baseline_id;