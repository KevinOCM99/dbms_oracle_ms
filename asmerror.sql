col name for a15
col path for a30
col mount_status for a20
col header_status for a10 heading HEADSTATS
select path,name,mount_status,header_status
from v$asm_disk
where WRITE_ERRS > 0

select path,name,mount_status,header_status
from v$asm_disk
where READ_ERRS > 0;