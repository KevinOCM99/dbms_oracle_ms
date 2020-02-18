SET SERVEROUT ON
SET PAGESIZE 1000
SET LONG 2000000
SET LINESIZE 400
SET SERVEROUT ON
SET FEEDBACK OFF

BEGIN

DBMS_OUTPUT.PUT_LINE('These AWR snapshots where created today:');
select snap_id from dba_hist_snapshot where to_char(begin_interval_time,'DD-MON-YY') = to_char(sysdate,'DD-MON-YY') order by snap_id;
END;
/

