select 'Show log level for schema level, next...gglogt' name from dual;

SELECT schema_name,
  supplemental_log_data_pk AS "PK",
  supplemental_log_data_pk AS "UI",
  supplemental_log_data_pk AS "FK",
  supplemental_log_data_pk AS "ALL"
FROM dba_capture_prepared_schemas
order by 1;
