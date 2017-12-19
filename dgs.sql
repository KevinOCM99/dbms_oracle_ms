col DEST_NAME for a10;
col STATUS for a10;
col DESTINATION for a20;
col ERROR for a10;
col PROTECTION_MODE for a20;
col rmode for a25;
SELECT replace(DEST_NAME, 'LOG_ARCHIVE_DEST', 'DEST') dest_name,
       recovery_mode rmode,STATUS,PROTECTION_MODE,DESTINATION,ERROR,SRL
FROM V$ARCHIVE_DEST_STATUS
WHERE DESTINATION IS NOT NULL
order by dest_id;
--ORDER BY to_number(substr(dest_name,instr(dest_name,'_',-1) + 1, length(dest_name) - instr(dest_name,'_', -1)));
