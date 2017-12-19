col numb for 99999;
col name for a40;
col value for a10;
select  nam.indx+1                            numb,
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
from    x$ksppi        nam,
        x$ksppsv       val
where   nam.indx = val.indx
        and upper(nam.ksppinm) like upper('%&newsort%');
