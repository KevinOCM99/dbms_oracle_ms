set pages 999
set lines 180;
col WRL_TYPE for a20;
col WRL_PARAMETER for a59;
col STATUS for a20;
col WALLET_TYPE for a20;
col WALLET_ORDER for a12
col FULLY_BACKED_UP for a9 Heading FULL_BKUP
col CON_ID for 999;
select * from v$encryption_wallet;




col KEY_ID for a52
col CREATOR_PDBNAME for a30;
col KEY_STATUS for a10;
SELECT con_id, key_id, CREATOR_PDBNAME, case CREATOR_PDBNAME when 'CDB$ROOT' then 'CDB-USED' else case (select count(1) from v$pdbs b where a.creator_pdbguid = b.guid) when 0 then 'NOT-USED' else 'PDB-USED' end end KEY_STATUS , activation_time
FROM v$encryption_keys a
order by KEY_STATUS,con_id;
