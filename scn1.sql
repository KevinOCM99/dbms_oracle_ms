set lines 180 pages 999;
col FILE_NAME for a50;
SELECT
    a.FILE#,
    a.NAME AS FILE_NAME,
    a.STATUS,
    a.CHECKPOINT_CHANGE# AS CHECKPOINT_SCN,
    b.CHECKPOINT_CHANGE# AS HEADER_SCN,
    a.LAST_CHANGE# AS END_SCN
FROM
    V$DATAFILE a inner join V$DATAFILE_HEADER b on a.FILE# = b.FILE#;

col name for a50;
select FILE#, name,checkpoint_count from V$DATAFILE_HEADER;
