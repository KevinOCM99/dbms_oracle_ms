select 'Show log level for database level, next...gglogs' name from dual;

select supplemental_log_data_min "Minimum",
supplemental_log_data_pk  "Primary key",
supplemental_log_data_ui  "Unique Key",
supplemental_log_data_fk  "Foregin Key",
supplemental_log_data_all "All"
FROM   v$database;

select name,log_mode,force_logging from v$database;

