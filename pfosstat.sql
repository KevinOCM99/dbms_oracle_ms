col stat_name for a30
col value for 99999999999999
col comments for a75
SELECT stat_name, value, comments
FROM v$osstat
order by 1;