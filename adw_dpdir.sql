col object_name for a50
col bytes for 999999999999999999
col created for a30
SELECT object_name,bytes,created FROM DBMS_CLOUD.LIST_FILES('DATA_PUMP_DIR') order by 1;
