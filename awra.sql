---------------------------------------------------------------------------
-- Query Name   : awrrptA.sql                                            --
-- Purpose      : @$ORACLE_HOME/rdbms/admin/awrrpti.sql                  --
-- DBMS Version : 11.2.0.2.0                                             --
-- Update Date  : 20131009-20140115                                      --
---------------------------------------------------------------------------
set verify       off
set termout      on
set feedback     off
set linesize     200
set pagesize     0
set trimspool    on
set serveroutput on
accept x prompt 'FROM(YYYY-MM-DD HH:MI): '
accept y prompt '  TO(YYYY-MM-DD HH:MI): '
spool awrrptTMP.sql

declare
  --extract snap ids from snap history:
  cursor c_wr is select p.snap_id
                      , p.begin_interval_time
                      , p.end_interval_time
                      , d.dbid
                      , d.name
                      , i.instance_number
                      , i.instance_name
                      , p.startup_time
                   from dba_hist_snapshot    p
                      , dba_hist_wr_control  w
                      , gv$database          d
                      , gv$instance          i
                  where i.inst_id=d.inst_id
                    and i.instance_number=p.instance_number
                    and w.dbid=d.dbid
                  --yesterday from 00:00-24:00
                  --and p.begin_interval_time >= trunc(sysdate)-1
                  --and p.end_interval_time   <= trunc(sysdate)+1/24
                    and p.begin_interval_time >= to_timestamp('&x','yyyy-mm-dd hh24:mi')-w.snap_interval/2*3
                    and p.end_interval_time   <= to_timestamp('&y','yyyy-mm-dd hh24:mi')+w.snap_interval/2
                  order by i.instance_number,p.begin_interval_time;
  c_snap         c_wr%rowtype;
  c_prev_snap    c_wr%rowtype;
  begin_time     varchar2(30);
  end_time       varchar2(30);
begin
  open c_wr;
    fetch c_wr into c_snap;
    while c_wr%found loop
      c_prev_snap:=c_snap;
      fetch c_wr into c_snap;
      if c_wr%found
      and c_snap.instance_number=c_prev_snap.instance_number
      and c_snap.startup_time=c_prev_snap.startup_time then
        begin_time := to_char(c_snap.begin_interval_time,'yyyymmdd_hh24mi');
        end_time   := to_char(c_snap.end_interval_time,  'yyyymmdd_hh24mi');
        dbms_output.put_line('--'||begin_time||' - '||end_time);
        dbms_output.put_line('define dbid        = '||c_snap.dbid||';');
        dbms_output.put_line('define db_name     = '''||c_snap.name||''';');
        dbms_output.put_line('define inst_num    = '||c_snap.instance_number||';');
        dbms_output.put_line('define inst_name   = '''||c_snap.instance_name||''';');
        dbms_output.put_line('define num_days    = 7;');
        dbms_output.put_line('define report_type = ''html'';');
        dbms_output.put_line('define begin_snap  = '||c_prev_snap.snap_id);
        dbms_output.put_line('define end_snap    = '||c_snap.snap_id);
        dbms_output.put_line('define report_name = ./awrrpt_'||c_snap.instance_name||'_'||begin_time||'-'||end_time||'.html');
        dbms_output.put_line('@?/rdbms/admin/awrrpti');
      end if;
    end loop;
  close c_wr;
end;
/

spool off
undefine x
undefine y
