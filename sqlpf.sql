col name for a30
COLUMN category FORMAT a10
COLUMN sql_text FORMAT a60
col status for a8
set lines 120

SELECT NAME, CATEGORY, STATUS, SQL_TEXT
FROM   DBA_SQL_PROFILES
order by 1,2;

