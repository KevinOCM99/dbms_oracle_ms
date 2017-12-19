set lines 120;
col mypurge for a100;
select distinct 'purge tablespace ' || tablespace_name ||' user '||owner || '; ' mypurge
from dba_segments
where owner || 'kk' ||segment_name in
(select owner || 'kk' ||object_name
 from dba_recyclebin);