col snap_id for 99999
col begin_interval_time for a25
col end_interval_time for a25
col snap_level for 99999 heading LEVEL
col snap_flag for 99999 heading FLAG
select *
from (
select snap_id,begin_interval_time,end_interval_time,snap_level,snap_flag
from dba_hist_snapshot
order by snap_id desc)
where rownum < 15;
