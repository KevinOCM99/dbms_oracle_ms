SET SERVEROUT ON
SET FEEDBACK OFF
DECLARE
 snap_id number;
 end_id number;
BEGIN
 DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT;
 SELECT max(snap_id)
 INTO end_id
 FROM dba_hist_snapshot;
 DBMS_OUTPUT.PUT_LINE('------------------------------------------');
 DBMS_OUTPUT.PUT_LINE('- AWR Snapshot with Snap-ID: ' || end_id || ' created. -');
 DBMS_OUTPUT.PUT_LINE('------------------------------------------');
END;
/
