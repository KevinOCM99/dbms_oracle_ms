set lines 180
col property_name for a45;
col PROPERTY_VALUE for a45;
col DESCRIPTION for a50;
SELECT *
FROM database_properties                
WHERE upper(property_name) like '%&prop_name%'
order by 1;
