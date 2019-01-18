--------------------------------------------------------
--  DDL for Table STATES
--------------------------------------------------------
CREATE TABLE "ADMIN"."STATES" 
(
"CITY" VARCHAR2(26 BYTE), 
"STATE" VARCHAR2(128 BYTE), 
"POSTAL_CODE" VARCHAR2(26 BYTE), 
"COUNTRY" VARCHAR2(26 BYTE), 
"LATITUDE" NUMBER(38,9), 
"LONGITUDE" NUMBER(38,9), 
"CONTINENT" VARCHAR2(26 BYTE), 
"REGION" VARCHAR2(26 BYTE)
 ) ;

--------------------------------------------------------
--  DDL for Table ORDER_LINES
--------------------------------------------------------
CREATE TABLE "ADMIN"."ORDER_LINES" 
(
"ORDER_LINE_ID" VARCHAR2(26 BYTE), 
"ORDER_ID" VARCHAR2(26 BYTE), 
"ORDER_PRIORITY" VARCHAR2(26 BYTE), 
"CUSTOMER_ID" VARCHAR2(26 BYTE), 
"CUSTOMER_NAME" VARCHAR2(100 BYTE), 
"CUSTOMER_SEGMENT" VARCHAR2(26 BYTE), 
"CITY" VARCHAR2(26 BYTE), 
"PRODUCT_CATEGORY" VARCHAR2(26 BYTE), 
"PRODUCT_SUB_CATEGORY" VARCHAR2(128 BYTE), 
"PRODUCT_CONTAINER" VARCHAR2(26 BYTE), 
"PRODUCT_NAME" VARCHAR2(100 BYTE), 
"PROFIT" NUMBER(38,2), 
"QUANTITY_ORDERED" NUMBER(38,0), 
"SALES" NUMBER(38,2), 
"DISCOUNT" NUMBER(38,2), 
"GROSS_UNIT_PRICE" NUMBER(38,2), 
"SHIPPING_COST" NUMBER(38,2), 
"SHIP_MODE" VARCHAR2(26 BYTE), 
"SHIP_DATE" DATE, 
"ORDER_DATE" DATE
 ) ;

set define off
begin
DBMS_CLOUD.create_credential(
credential_name => 'NEWKK_STORE_CRED',
username => 'OracleIdentityCloudService/yingwei01.zhou@gmail.com',
password => 'ZD>5-{KgJ60l_Xdpd1J:'
);
end;
/
set define on


declare job_id int;
BEGIN
DBMS_CLOUD.copy_data(
operation_id => job_id,
table_name => 'STATES',
credential_name => 'SL_STORE_CRED',
file_uri_list => 'https://swiftobjectstorage.us-ashburn-1.oraclecloud.com/v1/hongniu/adwdemo/states.csv',
schema_name => 'ADMIN',
--format => json_object('delimiter' value ',', 'recorddelimiter' value '''\\r\\n''', 'skipheaders' value '1', 'dateformat' value 'RRRR-MM-DD', 'quote' value '\"', 'rejectlimit' value '1000', 'trimspaces' value 'rtrim', 'ignoreblanklines' value 'true', 'ignoremissingcolumns' value 'true')
format => json_object('delimiter' value ',', 'recorddelimiter' value '''\r\n''', 'skipheaders' value '1', 'quote' value '\"', 'rejectlimit' value '0', 'trimspaces' value 'rtrim', 'ignoreblanklines' value 'false', 'ignoremissingcolumns' value 'true') 
); 
DBMS_CLOUD.delete_operation(id => job_id);
END;
/

select count(*) from states;
