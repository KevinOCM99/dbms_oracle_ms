col sid for 99999
col SERIAL# for 99999
col USERNAME for a15
col OBJECT_OWNER for a15
col OBJECT_NAME for a20
col OS_USER_NAME for a20
col locked_mode for a15

SELECT lo.session_id AS sid,
       s.serial#,
       NVL(lo.oracle_username, '(oracle)') AS username,
       o.owner AS object_owner,
       o.object_name,
       Decode(lo.locked_mode, 0, 'None',
                             1, 'Null (NULL)',
                             2, 'Row-S (SS)',
                             3, 'Row-X (SX)',
                             4, 'Share (S)',
                             5, 'S/Row-X (SSX)',
                             6, 'Exclusive (X)',
                             lo.locked_mode) locked_mode,
       lo.os_user_name,
       s.INST_ID
FROM   gv$locked_object lo
       JOIN dba_objects o ON o.object_id = lo.object_id
       JOIN gv$session s ON lo.session_id = s.sid
ORDER BY 1, 2, 3, 4;

