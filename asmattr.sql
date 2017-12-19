col name for a60
col value for a40
col group_number for 999
SELECT name, value, group_number 
FROM v$asm_attribute
where name like '%&attr_name%';