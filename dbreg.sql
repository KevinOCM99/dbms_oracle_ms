set lines 180
COL comp_name FOR a44 HEA 'Component' 
COL version FOR a17 HEA 'Version' 
COL status FOR a17 HEA 'Status' 
SELECT comp_name, version, status 
FROM dba_registry
order by 1;