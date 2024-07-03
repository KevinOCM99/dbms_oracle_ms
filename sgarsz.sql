set lines 180 pages 999;
col ops_date for a10;
col start_tm for a8;
col end_time for a8;
col component for a30;
SELECT to_char(start_time,'yyyy-mm-dd') ops_date, to_char(start_time,'hh24:mi:ss') start_tm, to_char(end_time,'hh24:mi:ss') end_time, component, oper_type, oper_mode, initial_size, target_size, final_size, status
FROM v$sga_resize_ops
ORDER BY 1, 2;

