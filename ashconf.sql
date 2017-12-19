col inst_id for 9999999
col pool for a15
col name for a25
col bytes for 999999999999
SELECT *
FROM gv$sgastat
WHERE name = 'ASH buffers'; 

col start_time for a25;
col end_time for a25;
select *
from 
(
select 'MEM' LOC
, inst_id
, to_char(min(sample_time),'YYYY-MM-DD_HH24:MI:SSXFF') start_time
, to_char(max(sample_time),'YYYY-MM-DD_HH24:MI:SSXFF') end_time
from gv$active_session_history
group by inst_id
union
select 'HIS' LOC
, INSTANCE_NUMBER inst_id
, to_char(min(sample_time),'YYYY-MM-DD_HH24:MI:SSXFF') start_time
, to_char(max(sample_time),'YYYY-MM-DD_HH24:MI:SSXFF') end_time
from dba_hist_active_sess_history 
group by INSTANCE_NUMBER) a
order by a.loc desc,inst_id;

@ashage.sql