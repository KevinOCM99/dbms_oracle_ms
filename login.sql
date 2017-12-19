-- Created by Junyi Liang 2005/1/28
set linesize 180;
set arraysize 999;
set verify off;
set serveroutput on;
set trimspool on;
set pagesize 9999;

alter session set nls_date_format = 'YYYY/MM/DD HH24:MI:SS';
--alter session set NLS_LANGUAGE = 'ENGLISH';

col HOST format a20;
col DB_LINK format a40;
col table_name format a40;
col comments format a50;
col COLUMN_NAME format a40;
col GRANTEE format a20;
col GRANTED_ROLE format a20;
col USERNAME format a50;
col PRIVILEGE format a40;
col MEMBER format a100;
col FILE_NAME format a100;
col guid format a40;
col TABLESPACE_NAME format a20;
col PASSWORD format a20;
col EXTERNAL_NAME format a20;
col ACCOUNT_STATUS format a20;
col value$ format a80;
col comment$ format a40;
col COMPONENT format a60;
col VALUE format a80;
col DESCRIPTION format a200;
col RESOURCE_CONSUMER_GROUP format a30;
col SCHEMANAME format a20;
col OSUSER format a10;
col CLIENT_IDENTIFIER format a20;
col TERMINAL format a10;
col PROGRAM format a30;
col MODULE format a30;
col CLIENT_INFO format a30;
col SPID format a10;

-- user_types
col TYPECODE format a30;
col TYPE_NAME format a30;
col SUPERTYPE_OWNER format a10;
col SUPERTYPE_NAME format a30;

--v$datafile
col AUX_NAME  format a20;
col NAME format a60;

--dba_tables
col INSTANCES format a15;
col CLUSTER_NAME format a20;
col CLUSTER_OWNER format a20;
col IOT_NAME format a20;

--v$spparameter
col SID format 99999999999999999999999999999;

--dba_registry
col COMP_NAME format a60;
col VERSION format a40;
col CONTROL format a15;
col SCHEMA format a15;
col STATUS format a15;

--DBA_LOGSTDBY_UNSUPPORTED
col DATA_TYPE format a15;

-- v$instance
col HOST_NAME format a15;

-- v$database
col force_logging format a16;
col FS_FAILOVER_OBSERVER_HOST format a40;
col PLATFORM_NAME format a40;

-- profile
col profile for a20;

-- user_indexes
col PARAMETERS format a20;
col INDEX_TYPE format a20;
col TABLE_OWNER format a20;
col DEGREE format a20;

-- userprofile 
col LASTNAME format a20;
col FIRSTNAME format a20;

--V$ARCHIVE_DEST
col DEST_NAME format a40;
col ALTERNATE format a20;
col DEPENDENCY format a40;
col DESTINATION format a60;
col REMOTE_TEMPLATE format a20;

--sys.sud$
col USERID format a20;
col USERHOST format a20;
col OBJ$CREATOR format a20;
col COMMENT$TEXT format a100;
col NEW$NAME format a100;
col CLIENTID format a20;
col SES$LABEL format a40;
col SPARE1 format a40;
col OBJ$LABEL format a40;
col  OBJ$NAME format a40;
col OBJ$LABEL format a40;

--DBA_AUDIT_OBJECT       
col OS_USERNAME format a20;
col NEW_OWNER format a20;
col NEW_NAME format a20;
col COMMENT_TEXT format a100;
col PRIV_USED format a60;
col CLIENT_ID format a20;
col OWNER format a25;
col OBJ_NAME format a40;

--col  format a40;
--DBA_XML_TABLES
col XMLSCHEMA format a80;
col SCHEMA_OWNER format a20;
col ELEMENT_NAME format a40;

--all_directories
col DIRECTORY_PATH format a100;

--DBA_HIST_FILESTATXS
col FILENAME format a100;

-- V$session
col P1TEXT format a20;
col P2TEXT format a20;
col P3TEXT format a20;
col WAIT_CLASS format a20;
col SERVICE_NAME format a20;
col EVENT format a30;


-- database_properties
col PROPERTY_NAME format a50;
col PROPERTY_VALUE format a60;


-- V$BACKUP_ARCHIVELOG_SUMMARY
col INPUT_BYTES_DISPLAY format a50;
col OUTPUT_BYTES_DISPLAY format a60;

col SEGMENT_NAME format a60;
col INSTANCE for a10;

-- parameter
COLUMN   VALUE_COL_PLUS_SHOW_PARAM FORMAT   a40
COLUMN   NAME_COL_PLUS_SHOW_PARAM FORMAT   a50
column   type for a15

@db;

show user

--prompt get from sql-login.sql
