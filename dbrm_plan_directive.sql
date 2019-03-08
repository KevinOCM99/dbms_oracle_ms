col plan for a30
col group_or_subplan for a30
col cpu_p1 for 999999
col cpu_p2 for 999999
col cpu_p3 for 999999
col cpu_p4 for 999999
SELECT plan,
       group_or_subplan,
       cpu_p1,
       cpu_p2,
       cpu_p3,
       cpu_p4
FROM   dba_rsrc_plan_directives
WHERE  plan like UPPER('&plan')||'%'
ORDER BY plan, cpu_p1 DESC, cpu_p2 DESC, cpu_p3 DESC;
