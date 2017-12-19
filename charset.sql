col PARAMETER for a40
col value for a20
SELECT parameter, value 
FROM nls_database_parameters 
WHERE parameter IN ('NLS_CHARACTERSET','NLS_NCHAR_CHARACTERSET');
