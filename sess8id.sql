column sid for 99999
COLUMN spid FORMAT A10
COLUMN username FORMAT A10
COLUMN program FORMAT A25
column schemaname for a15
column status for a10

SELECT s.inst_id,
       s.sid,
       s.serial#,
       p.spid,
       s.username,
       s.program,
       s.schemaname,
       s.status
FROM   gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.type != 'BACKGROUND'
and s.sid in (&sid_list);