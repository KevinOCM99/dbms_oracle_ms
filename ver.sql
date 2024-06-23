set lines 120;
col product for a39;
col VERSION for a15;
col version_full for a15;
col status for a20;
SELECT * FROM PRODUCT_COMPONENT_VERSION
 WHERE product LIKE 'Oracle Database%';

