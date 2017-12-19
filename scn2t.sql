col MyTime for a20;
col CurrentTime for a20;
select to_char(scn_to_timestamp(&myscn),'yyyy-mm-dd hh24:mi:ss') MyTime
, to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') CurrentTime
from dual;