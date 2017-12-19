col id for 99
col name for a15
select group_number id,
       name,
       type,
       total_mb,
       free_mb,
       HOT_USED_MB,
       COLD_USED_MB,
       REQUIRED_MIRROR_FREE_MB REQUIRED_MB,
       USABLE_FILE_MB USABLE_MB
  from v$asm_diskgroup
 order by id,name;

