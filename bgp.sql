col ins_id for 99
col pserial# for 999
col name for a10
col description for a50
col PADDR for a30
select inst_id, pserial#,name,description,PADDR
from gv$bgprocess
where paddr <> '00'
order by 1,3;
