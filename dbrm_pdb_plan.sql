SELECT
    group_or_subplan,
    mgmt_p1,
    mgmt_p2,
    mgmt_p3,
    mgmt_p4,
    mgmt_p5,
    mgmt_p6,
    mgmt_p7,
    mgmt_p8,
    max_utilization_limit
FROM
    dba_rsrc_plan_directives
WHERE
    plan =(
        SELECT
            name
        FROM
            v$rsrc_plan
        WHERE
            is_top_plan = 'TRUE'
    );
