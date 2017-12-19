set lines 120;
col mypurge for a100;
 select distinct 'purge tablespace ' || default_tablespace ||' user '||username || '; ' mypurge
from dba_users
where username || 'kk'  in
(select owner || 'kk'
 from dba_recyclebin);