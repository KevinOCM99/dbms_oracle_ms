set lines 120 pages 999;
col comp_id for a10;
col version for a11;
col status for a10;
col comp_name for a37;
select comp_id,comp_name,version,status from dba_registry;
