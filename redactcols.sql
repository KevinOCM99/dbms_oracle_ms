COLUMN object_owner FORMAT A15
COLUMN object_name FORMAT A20
COLUMN column_name FORMAT A20
COLUMN function_parameters FORMAT A20
COLUMN regexp_pattern FORMAT A15
COLUMN regexp_replace_string FORMAT A30
COLUMN column_description FORMAT A20

SELECT object_owner,
       object_name,
       column_name,
       function_type,
       function_parameters,
       regexp_pattern,
       regexp_replace_string,
       regexp_position,
       regexp_occurrence,
       regexp_match_parameter,
       column_description
FROM   redaction_columns
WHERE  object_owner like UPPER('%&owner%')
AND    object_name  like UPPER('%&tab%')
ORDER BY 1, 2, 3;