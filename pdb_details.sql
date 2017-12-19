col con_id for 99;
col con_name for a10;
col instance_name for a15;
col state for a20;
col restricted for a10;
col application_root for a4 heading ROOT
col application_pdb for a4 heading APDB
col application_root_con_id for 99
select con_id, name, application_root, application_pdb, application_root_con_id 
from v$containers;