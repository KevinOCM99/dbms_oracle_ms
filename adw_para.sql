col name for a40;
col value for a10;
col default_value for a15;
col isdefault for a15;
col ISSES_MODIFIABLE for a10 heading ISSESMOD
col ISSYS_MODIFIABLE for a10 heading ISSYSMOD
col ISPDB_MODIFIABLE for a10 heading ISPDBMOD
col ISMODIFIED for a10 heading ISMOD?
select a.name,
a.value,
a.default_value,
a.isdefault,
a.ISSES_MODIFIABLE      ,
a.ISSYS_MODIFIABLE      ,
a.ISPDB_MODIFIABLE      ,
a.ISMODIFIED           
from v$parameter a
where a.name like 'max_idle_time%' order by name;
