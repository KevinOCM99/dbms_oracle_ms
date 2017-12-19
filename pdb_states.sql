col con_id for 99;
col con_name for a10;
col instance_name for a15;
col state for a20;
col restricted for a10;
select con_id,con_name,instance_name,state,restricted 
from dba_pdb_saved_states;
