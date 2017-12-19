col source_time for a30;
col target_time for a30;
col GAP8 for 9999;
select to_char(TIMESTAMP,'yyyy-mm-dd hh24:mi:ss') source_time,
to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') target_time
from MDM_FIL.HEARTBEAT;

select round((sysdate-TIMESTAMP) * 24 * 60) - 480 GAP8
from mdm_fil.heartbeat;