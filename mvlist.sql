col owner for a15;
col mview_name for a35;
col refresh_mode for a10 heading Ref_Mode;
col refresh_method for a10 heading Ref_Method;
col fast_refreshable for a10 heading Fast_Ref?;
col last_refresh_date for a20 heading Last_Refresh_Time;
SELECT owner,mview_name, refresh_mode, refresh_method,
       last_refresh_type, last_refresh_date
FROM dba_mviews
where owner like upper('&owner%')
and mview_name like upper('&mv%')
order by 1,2;