undefine sql_id;
col signature for 999999999999999999999999;
SELECT exact_matching_signature signature FROM v$sql WHERE sql_id = '&&sql_id.'
union
SELECT DBMS_SQLTUNE.SQLTEXT_TO_SIGNATURE(sql_text) signature FROM dba_hist_sqltext WHERE sql_id = '&&sql_id.' AND ROWNUM = 1;

