col id for 99
col name for a20
col path for a25
col failgroup for a15
col allocation_unit_size heading au_size
col state for a15
col type for a15
col failgroup for a15
col mount_status for a8 heading MSTATS
col header_status for a11 heading HEADERSTATS 
col mode_status for a8 heading PSTATS noprint
col state for a8
col os_gb for 99999
col total for 99999
col free for 99999

break on id on failgroup
select group_number id,
       failgroup,
       name,
       path,
       mount_status,
       header_status,
       mode_status,
       state,
       os_mb /1024 os_gb,
       total_mb /1024 total,
       free_mb / 1024 free
  from v$asm_disk
 order by id, name, path;
clear break;