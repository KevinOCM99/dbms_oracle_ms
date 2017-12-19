col sql_id for a50
SELECT  distinct sql_id
FROM v$sqltext a
WHERE (a.hash_value, a.address) IN 
(SELECT DECODE (sql_hash_value,0, prev_hash_value,sql_hash_value ),
        DECODE (sql_hash_value, 0, prev_sql_addr, sql_address)
 FROM v$session b  WHERE b.sid= '&sid');
