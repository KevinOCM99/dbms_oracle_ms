set lines 120
col property_name for a35;
col PROPERTY_VALUE for a30;
col DESCRIPTION for a50;
SELECT *
FROM database_properties                
WHERE property_name = 'DEFAULT_TBS_TYPE';