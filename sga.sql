
set lines 130 pages 999;
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

