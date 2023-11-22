Rem
Rem $Header: 4-Nov-2014.09:40:32 Mike Feng $
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem  

spool /tmp/analysis.lst
set serveroutput on size unlimited
set lines 500
set pages 9999
set long 1000000
variable b_sess number;
--add in May 15 
variable instance_id varchar2(10);
prompt Please input instance ID(e.g. 1):
exec :instance_id := '&instance_id';
prompt Please input suspected blocking session ID:
exec :b_sess := &blocking_sess;
declare
  l_blocking_session number;
  cursor cur(p_snap_id number,p_sample_id number)
  is 
    select tt.*,rownum rn
    from (
    select snap_id,sample_id,sample_time,session_id,session_serial#,sql_id,blocking_session,event
      , p1text,p2text,p3text,p1,p2,p3
    from m_dba_hist_active_sess_history
    where instance_number = trim(:instance_id)
    and snap_id   = p_snap_id
    and sample_id =p_sample_id
    ) tt
    start with session_id = l_blocking_session 
    connect by prior session_id =  blocking_session;
  rec_cur cur%rowtype;
  procedure pt(p_rec cur%rowtype)
  is
  begin
    if p_rec.rn = 1 then
      dbms_output.put_line(rpad('Sample Time',20)||rpad('Session_id',15)||rpad('Session_Serial#',20)||rpad('SQL_ID',15)||rpad('BLOCKING_SESSION',20)
        ||rpad('Event',35)||rpad('P1TEXT,P2TEXT,P3TEXT',30)||rpad('P1,P2,P3',20));
      dbms_output.put_line(rpad('-----------',20)||rpad('----------',15)||rpad('---------------',20)||rpad('------',15)||rpad('----------------',20)
        ||rpad('-----',35)||rpad('--------------------',30)||rpad('--------',20));
    end if;
    dbms_output.put_line(rpad(to_char(p_rec.sample_time,'yyyy/mm/dd hh24:mi:ss'),20)
    ||rpad(p_rec.session_id,15)||rpad(p_rec.session_serial#,20)||rpad(nvl(p_rec.sql_id,' '),15)||rpad(nvl(to_char(p_rec.blocking_session),' '),20)
    ||rpad(nvl(p_rec.event,' '),35)||rpad(p_rec.p1text||','||p_rec.p2text||','||p_rec.p3text,30)||rpad(p_rec.p1||','||p_rec.p2||','||p_rec.p3,20));
  end;  
begin
  l_blocking_session := :b_sess;
  for sm in (select distinct snap_id,sample_id from m_dba_hist_active_sess_history order by snap_id,sample_id) loop
    dbms_output.new_line;
    dbms_output.new_line;
    dbms_output.put_line('Snap ID: '||to_char(sm.snap_id)||'   Sample ID: '||to_char(sm.sample_id));
    for rec in cur(sm.snap_id,sm.sample_id) loop
      pt(rec);
    end loop;
  end loop;
end;
/
spool off;