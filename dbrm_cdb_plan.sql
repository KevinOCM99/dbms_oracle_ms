SELECT
    pluggable_database,
    shares,
    utilization_limit
FROM
    dba_cdb_rsrc_plan_directives
WHERE
    plan =(
        SELECT
            name
        FROM
            v$rsrc_plan
        WHERE
            is_top_plan = 'TRUE'
            AND con_id = 1
    );
