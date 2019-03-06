col cdb_or_not for a15 heading 'CDB Or Not?';
SELECT Case CDB when 'YES' then 'Container DB' else 'Non-Container' end CDB_or_NOT FROM V$DATABASE; 
