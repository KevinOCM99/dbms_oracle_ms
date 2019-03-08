SELECT
    TO_CHAR(m.begin_time,'HH:MI')time,
    m.consumer_group_name,
    m.cpu_consumed_time / 60000 avg_running_sessions,
    m.cpu_wait_time / 60000 avg_waiting_sessions,
    d.mgmt_p1 *(
        SELECT
            value
        FROM
            v$parameter
        WHERE
            name = 'cpu_count'
    )/ 100 allocation
FROM
    v$rsrcmgrmetric_history    m,
    dba_rsrc_plan_directives   d,
    v$rsrc_plan                p
WHERE
    m.consumer_group_name = d.group_or_subplan
    AND p.name = d.plan
ORDER BY
    m.begin_time,
    m.consumer_group_name;	
