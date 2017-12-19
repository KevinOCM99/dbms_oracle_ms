SET LINESIZE 200
column sid for 9999
COLUMN spid FORMAT A10
COLUMN program FORMAT A25
column schemaname for a15
column machine for a20

SELECT s.inst_id,
       s.sid,
       s.serial#,
       p.spid,
       s.osuser,
       s.machine,
       s.program,
       s.schemaname
FROM   gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.type != 'BACKGROUND'
and s.username = upper('&username');
