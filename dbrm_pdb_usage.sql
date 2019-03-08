SELECT
    TO_CHAR(begin_time,'HH24:MI'),
    name,
    SUM(avg_running_sessions)avg_running_sessions,
    SUM(avg_waiting_sessions)avg_waiting_sessions
FROM
    v$rsrcmgrmetric_history   m,
    v$pdbs                    p
WHERE
    m.con_id = p.con_id
GROUP BY
    begin_time,
    m.con_id,
    name
ORDER BY
    begin_time;
    
