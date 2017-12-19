set lines 120
col numb for 99999;
col name for a40;
col value for a20;
col is_default for a7 heading "Default"
column is_session_modifiable for a7 heading "Session"
column is_system_modifiable for a9 heading "System"
column is_modified for a8 heading "Modified"
column is_adjusted for a8 heading "Adjusted"
col type for 99
select 
        nam.indx+1                            numb,
        nam.ksppinm                           name,
        val.ksppstvl                          value,
        nam.ksppity                           type,
        val.ksppstdf                          is_default,
        decode(bitand(nam.ksppiflg/256,1),
               1,'True',
                 'False'
        )                                     is_session_modifiable,
        decode(bitand(nam.ksppiflg/65536,3),
               1,'Immediate',
               2,'Deferred' ,
               3,'Immediate',
                 'False'
        )                                     is_system_modifiable,
        decode(bitand(val.ksppstvf,7),
               1,'Modified',
               4,'System Modified',
                 'False'
        )                                     is_modified,
        decode(bitand(val.ksppstvf,2),
               2,'True',
                 'False'
        )                                     is_adjusted     
	--,        nam.ksppdesc                          description
from
        x$ksppi        nam,
        x$ksppsv       val
where 
        nam.indx = val.indx
        and nam.ksppinm like '%&newsort%'
order by nam.ksppinm;
