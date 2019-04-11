set echo off;
COLUMN current_time FORMAT A20
COLUMN version FORMAT A70
SET NUMF 99999999999
SELECT value version,
       d.name,
       TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') current_time
 FROM rasys.config c, v$database d
 WHERE c.name = '_build';
