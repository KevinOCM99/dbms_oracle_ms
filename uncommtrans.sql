SET termout ON
SET heading ON
SET PAGESIZE   40 
SET LINESIZE   120
SET FEEDBACK   on

COLUMN pgm_notes    FORMAT a80        HEADING 'Notes'
COLUMN rbs          FORMAT a25        HEADING 'Undo Segment'
COLUMN oracle_user  FORMAT a20        HEADING 'Oracle|Username'
COLUMN sid_serial   FORMAT a12        HEADING 'SID,Serial'
COLUMN unix_pid     FORMAT a6         HEADING 'O/S|PID'
COLUMN Client_User  FORMAT a20        HEADING 'Client|Username'
COLUMN Unix_user    FORMAT a12        HEADING 'O/S|Username'
COLUMN login_time   FORMAT a17        HEADING 'Login Time'
COLUMN last_txn     FORMAT a17        HEADING 'Last Active'
COLUMN undo_kb      FORMAT 99,999,999 HEADING 'Undo KB'

TTITLE CENTER 'Who/What is Using Which Undo/RBS'  -
  skip Center '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' -
  skip 2
repfooter off
btitle    off

 SELECT r.name                   rbs,
        nvl(s.username, 'None')  oracle_user,
        s.osuser                 client_user,
        p.username               unix_user,
        to_char(s.sid)||','||to_char(s.serial#) as sid_serial,
        p.spid                   unix_pid,
--        TO_CHAR(s.logon_time, 'mm/dd/yy hh24:mi:ss') as login_time,
--        TO_CHAR(sysdate - (s.last_call_et) / 86400,'mm/dd/yy hh24:mi:ss') as last_txn,
        t.used_ublk * TO_NUMBER(x.value)/1024  as undo_kb
   FROM v$process     p,
        v$rollname    r,
        v$session     s,
        v$transaction t,
        v$parameter   x
  WHERE s.taddr = t.addr
    AND s.paddr = p.addr(+)
    AND r.usn   = t.xidusn(+)
    AND x.name  = 'db_block_size'
  ORDER
     BY r.name
;

set feedback on
TTITLE off