col pserial# for 999
col name for a10
col description for a50
col PADDR for a30
select pserial#,name,description,PADDR
from v$bgprocess
where paddr <> '00'
order by 1,2;