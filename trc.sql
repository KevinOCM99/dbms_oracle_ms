set lines 120 pages 999
col INST_ID for 999;
col NAME for a45;
col VALUE for a65;
select INST_ID,NAME,VALUE  
from V$DIAG_INFO
where name = 'Diag Trace';

SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Default Trace File';

col value for a120;
select '$ORACLE_BASE/diag/rdbms/your_db/your_sid/trace/alert_yoursid.log' value from dual
union
select '%ORACLE_BASE%\diag\rdbms\%Your_DB%\%Your_Instance%\trace\alert_%Your_Instance%.log' value from dual;


select '$ORACLE_BASE/diag/tnslsnr/<hostname>/listener/trace/listener.log' value from dual
union
select '%ORACLE_BASE%\diag\tnslsnr\<hostname>\listener\trace\listener.log' value from dual;
