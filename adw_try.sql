DROP TABLE customers_kk purge;

begin
DBMS_CLOUD.drop_credential(
credential_name => 'OBJ_STORE_CRED'
);
end;
/


CREATE TABLE customers_kk (
cust_id NUMBER NOT NULL,
cust_first_name VARCHAR2(20) NOT NULL,
cust_last_name VARCHAR2(40) NOT NULL,
cust_gender CHAR(1) NOT NULL,
cust_year_of_birth NUMBER(4) NOT NULL,
cust_marital_status VARCHAR2(20) ,
cust_street_address VARCHAR2(40) NOT NULL,
cust_postal_code VARCHAR2(10) NOT NULL,
cust_city VARCHAR2(30) NOT NULL,
cust_city_id NUMBER NOT NULL,
cust_state_province VARCHAR2(40) NOT NULL,
cust_state_province_id NUMBER NOT NULL,
country_id NUMBER NOT NULL,
cust_main_phone_number VARCHAR2(25) NOT NULL,
cust_income_level VARCHAR2(30) ,
cust_credit_limit NUMBER ,
cust_email VARCHAR2(50) ,
cust_total VARCHAR2(14) NOT NULL,
cust_total_id NUMBER NOT NULL,
cust_src_id NUMBER ,
cust_eff_from DATE ,
cust_eff_to DATE ,
cust_valid VARCHAR2(1) );


set define off;
begin
DBMS_CLOUD.create_credential(
credential_name => 'OBJ_STORE_CRED',
username => 'zhanghongtao8658@dingtalk.com',
password => ':1fslc><Bb2Nk-8+G0P('
);
end;
/
set define on;


declare job_id int;
BEGIN
DBMS_CLOUD.copy_data(
operation_id => job_id,
table_name => 'CUSTOMERS_KK',
credential_name => 'OBJ_STORE_CRED',
file_uri_list => 'https://swiftobjectstorage.us-ashburn-1.oraclecloud.com/v1/kkwizard01/ADWCLab/customers.csv',
schema_name => 'ADMIN',
format => json_object('delimiter' value '|', 'recorddelimiter' value '''\\n''', 'dateformat' value 'YYYY-MM-DD-HH24-MI-SS', 'quote' value '\"', 'rejectlimit' value '0', 'trimspaces' value 'rtrim', 'ignoreblanklines' value 'true', 'ignoremissingcolumns' value 'true')); 
DBMS_CLOUD.delete_operation(id => job_id);
END;
/

select count(*) from customers_kk;		
