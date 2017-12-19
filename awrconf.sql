col snap_interval for a20
col retention  for a20
col AWR_SPACE_MB for 9999999999
select snap_interval,retention
from dba_hist_wr_control;

SELECT space_usage_kbytes/1024 AWR_SPACE_MB
FROM v$sysaux_occupants
WHERE occupant_name = 'SM/AWR';
