col GROUP_NUMBER heading id for 999;
col OPERATION for a10;
select GROUP_NUMBER,OPERATION,state,power,EST_MINUTES
from v$asm_operation;
