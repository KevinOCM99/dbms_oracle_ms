set lines 180
col property_name for a45;
col PROPERTY_VALUE for a85;
SELECT property_name,property_value
FROM database_properties                
WHERE upper(property_name) like '%&prop_name%'
order by 1;
