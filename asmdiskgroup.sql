col id for 99
col name for a15
col path for a30
col failgroup for a15
col mount_status for a20
col allocation_unit_size for 9999 heading UNIT
col state for a10
col type for a7
col unit for 9999
col failgroup for a20
col path for a40
col mount_status for a15
COLUMN compatibility FORMAT A10 heading  ASM_COMP  justify right
COLUMN database_compatibility FORMAT A10 heading  DB_COMP justify right

select group_number id,
       name,
       block_size,
       allocation_unit_size / 1024 / 1024 allocation_unit_size,
       state,
       type,
       total_mb,
       free_mb,
       USABLE_FILE_MB USABLE_MB,
       compatibility, 
       database_compatibility
  from v$asm_diskgroup
 order by id,name;

