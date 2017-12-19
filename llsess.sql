col idlehours for a15
col username for a15
col status for a10
col machine for a30
col osuser for a15
col UNIXPID for a5 heading OSPID
--col unixkill for a20
col logontime for a20
col idlesecond for 9999999
SELECT TO_CHAR(TRUNC(last_call_et / 3600, 0)) || ' ' || ' HRS ' ||
       TO_CHAR(TRUNC((last_call_et - TRUNC(last_call_et / 3600, 0) * 3600) / 60,
                     0)) || ' MINS' idlehours,
       s.username,
       s.status,
       osuser,
       spid UNIXpid,
--       'kill -9 ' || spid UNIXKill,
--       'alter system kill session ' || '''' || s.sid || ',' || s.serial# || ''';' OracleKill,
       TO_CHAR(logon_time, 'dd/mm/yyyy hh24:mi:ss') logontime
--,    last_call_et idlesecond
,
       s.machine
  FROM gv$session s, gv$process p
 WHERE TYPE = 'USER'
   AND p.addr = s.paddr
   AND status != 'KILLED'
      -- AND SUBSTR (machine, 1, 19) NOT IN ('machine name list')
   AND last_call_et > 60 * 60 * 1 -- longer than 1 hour
 ORDER BY last_call_et desc;

