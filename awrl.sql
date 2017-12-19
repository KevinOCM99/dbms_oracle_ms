set verify       off
set termout      on
set feedback     off
set linesize     200
set pagesize     0
set trimspool    on
set serveroutput on
accept x prompt 'FROM(YYYY-MM-DD HH:MI): '
accept y prompt '  TO(YYYY-MM-DD HH:MI): '
--spool awrrptTMP.sql

declare
  db_id      v$database.dbid%type;
  db_name    v$database.name%type;
  inst_id    v$instance.instance_number%type;
  inst_name  v$instance.instance_name%type;
  --extract snap ids from snap history
  cursor l_cur is select p.snap_id
                        ,p.begin_interval_time
                        ,p.end_interval_time
                    from dba_hist_snapshot    p
                        ,v$instance           c
                        ,dba_hist_wr_control  w
                   where p.instance_number=c.instance_number
                   --yesterday from 00:00-24:00
                   --and p.begin_interval_time >= trunc(sysdate)-1
                   --and p.end_interval_time   <= trunc(sysdate)+1/24
                     and p.begin_interval_time >= to_timestamp('&x','yyyy-mm-dd hh24:mi')-w.snap_interval/2*3
                     and p.end_interval_time   <= to_timestamp('&y','yyyy-mm-dd hh24:mi')+w.snap_interval/2
                   order by p.begin_interval_time;
  l_rec         l_cur%rowtype;
  l_prev_rec    l_cur%rowtype;
  l_begin_date  varchar2(30);
  l_end_date    varchar2(30);
  l_begin_time  varchar2(30);
  l_end_time    varchar2(30);

begin
  select dbid           ,name          into db_id  ,db_name   from v$database;
  select instance_number,instance_name into inst_id,inst_name from v$instance;
  open l_cur;
  fetch l_cur into l_rec;
  while l_cur%found loop
    l_prev_rec:=l_rec;
    fetch l_cur into l_rec;
    if l_cur%found then
      l_begin_date := to_char(l_rec.begin_interval_time,'yyyy-mm-dd hh24:mi');
      l_end_date   := to_char(l_rec.end_interval_time,  'yyyy-mm-dd hh24:mi');
      l_begin_time := to_char(l_rec.begin_interval_time,'yyyymmdd_hh24mi');
      l_end_time   := to_char(l_rec.end_interval_time,  'yyyymmdd_hh24mi');
      dbms_output.put_line('--'||l_begin_date||' - '||l_end_date);
      dbms_output.put_line('define dbid        = '||db_id||';');
    --dbms_output.put_line('define db_name     = '''||db_name||''';');
      dbms_output.put_line('define inst_num    = '||inst_id||';');
      dbms_output.put_line('define inst_name   = '''||inst_name||''';');
      dbms_output.put_line('define num_days    = 7;');
      dbms_output.put_line('define report_type = ''html'';');
      dbms_output.put_line('define begin_snap  = '||l_prev_rec.snap_id);
      dbms_output.put_line('define end_snap    = '||l_rec.snap_id);
      dbms_output.put_line('define report_name = ./awrrpt_'||inst_name||'_'||l_begin_time||'-'||l_end_time||'.html');
      dbms_output.put_line('@?/rdbms/admin/awrrpti');
    end if;
  end loop;
  close l_cur;
end;
/

--spool off
undefine x
undefine y
