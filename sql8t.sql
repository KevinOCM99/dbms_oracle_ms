col sql_id for a30
col child_number for 999999999
col is_bind_sensitive for a20
col is_bind_aware for a20
col is_shareable for a20
SELECT sql_id, child_number, is_bind_sensitive, is_bind_aware, is_shareable
FROM v$sql
WHERE sql_text like '%&text%'
ORDER BY sql_id,child_number;
