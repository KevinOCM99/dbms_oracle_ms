
set lines 180 pages 999;
col COMPONENT for a40;
col CURRENT_SIZE_MB for 9999999999999;
col MIN_SIZE_MB for 9999999999999;
col MAX_SIZE_MB for 9999999999999;
col USER_SPECIFIED_SIZE_MB for 9999999999999;
SELECT
    COMPONENT,
    CURRENT_SIZE / 1024 / 1024 AS CURRENT_SIZE_MB,
    MIN_SIZE / 1024 / 1024 AS MIN_SIZE_MB,
    MAX_SIZE / 1024 / 1024 AS MAX_SIZE_MB,
    USER_SPECIFIED_SIZE / 1024 / 1024 AS USER_SPECIFIED_SIZE_MB
FROM
    V$MEMORY_DYNAMIC_COMPONENTS
where CURRENT_SIZE > 0
order by 1;


col Component for a40;
col "Memory (MB)" for 99999999999.00
SELECT
    'SGA Memory - Used' AS "Component",
    SUM(BYTES) / 1024 / 1024 AS "Memory (MB)"
FROM
    V$SGASTAT
UNION ALL
SELECT
    'SGA Memory - Allocated' AS "Component",
    SUM(value) / 1024 / 1024 AS "Memory (MB)"
FROM
    V$SGA
UNION ALL
SELECT
    'PGA Memory' AS "Component",
    SUM(value) / 1024 / 1024 AS "Memory (MB)"
FROM
    V$PGASTAT
WHERE
    NAME = 'total PGA inuse'
UNION ALL
SELECT
    'Total Host Memory' AS "Component",
    ROUND((SELECT value FROM V$OSSTAT WHERE STAT_NAME = 'PHYSICAL_MEMORY_BYTES') / 1024 / 1024) AS "Memory (MB)"
FROM
    dual;
    
    
col last_oper_type for a15   head "Operation|Type"
col last_oper_mode for a15  head "Operation|Mode"
col lasttime for a25 head "Timestamp"

select component, last_oper_type, last_oper_mode, 
  to_char(last_oper_time, 'mm/dd/yyyy hh24:mi:ss') lasttime
from v$memory_dynamic_components
/

select component, user_specified_size, current_size, min_size, max_size, granule_size
from v$memory_dynamic_components
/

select component, user_specified_size, current_size, min_size, max_size, granule_size
from v$memory_dynamic_components
/
