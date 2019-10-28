COLUMN parameter_name FORMAT A40
COLUMN parameter_value FORMAT A15

SELECT con_id, parameter_name, parameter_value 
FROM   cdb_auto_index_config
ORDER BY 1, 2;
