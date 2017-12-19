SELECT  distinct sql_id
FROM v$sqltext a
WHERE (a.hash_value, a.address) IN 
(SELECT DECODE (sql_hash_value,0, prev_hash_value,sql_hash_value ),
        DECODE (sql_hash_value, 0, prev_sql_addr, sql_address)
 FROM v$session b  WHERE b.sid= '&sid');



undefine sql_id;
select sid
from v$session
where (DECODE (sql_hash_value,0, prev_hash_value,sql_hash_value ), DECODE (sql_hash_value, 0, prev_sql_addr, sql_address))
in
(select a.hash_value, a.address
from v$sqltext a
where a.sql_id = '&sql_id');


86ufp0u693x1b


select sid, DECODE (sql_hash_value,0, prev_hash_value,sql_hash_value ), DECODE (sql_hash_value, 0, prev_sql_addr, sql_address),
from v$session

select a.hash_value, a.address
from v$sqltext a
where a.sql_id = '&sql_id'


select a.hash_value, a.address
from v$sql a
where a.sql_id = '&sql_id'


select a.hash_value, a.address
from v$sql a
where a.sql_id = '86ufp0u693x1b';


select sid, DECODE (sql_hash_value,0, prev_hash_value,sql_hash_value ), DECODE (sql_hash_value, 0, prev_sql_addr, sql_address)
from v$session
where sid  = 527;