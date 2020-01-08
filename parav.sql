--also can use view of 
--select value from v$parameter_valid_values where name ='optimizer_features_enable' order by ORDINAL;
COL pvalid_default HEAD DEFAULT FOR A7
COL pvalid_value   HEAD VALUE   FOR A30
COL pvalid_name    HEAD PARAMETER FOR A50
COL pvalid_par#    HEAD PAR# FOR 99999

BREAK ON pvalid_par# skip 1

SELECT 
--  INST_ID, 
  PARNO_KSPVLD_VALUES     pvalid_par#,
  NAME_KSPVLD_VALUES      pvalid_name, 
  ORDINAL_KSPVLD_VALUES   ORD, 
  VALUE_KSPVLD_VALUES  pvalid_value,
  DECODE(ISDEFAULT_KSPVLD_VALUES, 'FALSE', '', 'DEFAULT' ) pvalid_default
FROM 
  X$KSPVLD_VALUES 
WHERE 
  LOWER(NAME_KSPVLD_VALUES) LIKE LOWER('%&para%')
ORDER BY
  pvalid_par#,
  pvalid_default,
  ord,
  pvalid_Value
/


