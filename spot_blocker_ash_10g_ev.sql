Rem
Rem $Header: 4-Nov-2014.09:40:32 Mike Feng $
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem  
set serveroutput on size unlimited
set lines 10000
set pages 9999
set long 1000000
SET TRIMS ON
--set feedback off
variable instance_id varchar2(10);
prompt Please input instance ID:
exec :instance_id := trim('&instance_id');
spool  /tmp/spot_blocker.lst
declare
  cursor spot_blocker_cur(p_instance_number number,p_sample_id number)
  is
  select rownum row_num, ee.*
  from (
  select distinct
      round(sum(rat) over (partition by instance_number,sample_id,session_id,session_serial#),2) rat_sum
  --  , rat
  --  , lv
  --  , row_num
  --  , max(flag) over (order by instance_number,sample_id,row_num rows between lv preceding and current row) flag
    ,instance_number
    ,sample_id
    ,sample_time
    ,session_id
    ,session_serial#
    ,sql_id
    ,event
    ,ptext
    ,p123
    ,cycle_flag
    ,program
    ,blocking_session
    ,blocking_session_serial#
  from (
    select
          lv/count(*) over (partition by instance_number,sample_id,flag) rat
        , lv
        , row_num
        , max(flag) over (order by instance_number,sample_id,row_num rows between lv preceding and current row) flag
        ,instance_number
        ,sample_id
        ,sample_time
        ,session_id
        ,session_serial#
        ,sql_id
        ,event
        ,ptext
        ,p123
        ,cycle_flag
        ,program
        ,blocking_session
        ,blocking_session_serial#
    from (
      select 
          lv
        , row_num
        , max(flag) over (order by instance_number,sample_id,row_num rows between lv preceding and current row) flag
        ,instance_number
        ,sample_id
        ,sample_time
        ,session_id
        ,session_serial#
        ,sql_id
        ,event
        ,p1text||', '||p2text||', '||p3text  ptext
        ,to_char(p1)||', '||to_char(p2)||', '||to_char(p3) p123
        ,decode(cycle_flag,1,'Cycle',' ') cycle_flag
        ,program
        ,blocking_session1 blocking_session
        ,blocking_session_serial#
      from (
        select level lv, rownum row_num,case when level = 1 then level + rownum else null end flag,connect_by_iscycle cycle_flag,aa.*
        from (
          select mm.*
		    ,case 
			 when event = 'cursor: pin S wait on X' and blocking_session is null then 
			 decode(trunc(P2/4294967296),0,trunc(P2/65536),trunc(P2/4294967296))  
			 else blocking_session end blocking_session1
          from m_DBA_HIST_ACTIVE_SESS_history mm
          where sample_id = p_sample_id
          and instance_number = p_instance_number
        ) aa
        start with blocking_session1 is not null
        connect by nocycle session_id = prior blocking_session1) bb) cc) dd
  order by round(sum(rat) over (partition by instance_number,sample_id,session_id,session_serial#),2) desc) ee
  where rownum <= 10;
  cursor analyze_ash_cur(p_instance_number number)
  is
  select distinct instance_number,sample_id,sample_time from m_DBA_HIST_ACTIVE_SESS_history where p_instance_number is null or instance_number = p_instance_number 
  order by instance_number,sample_id;
begin
  for rec in analyze_ash_cur(:instance_id) loop
    dbms_output.put_line('Instance Number: '||to_char(rec.instance_number)||'  Sample ID:'||to_char(rec.sample_id)
    ||'  Sample time:'||to_char(rec.sample_time,'yyyy/mm/dd hh24:mi:ss'));
    for b_rec in spot_blocker_cur(rec.instance_number,rec.sample_id) loop
      if b_rec.row_num = 1 then
        dbms_output.put_line(rpad('No.',5,' ')||rpad('Ratio',10,' ')||rpad('Session_ID',12,' ')||rpad('Serial#',12,' ')||rpad('sql_id',20,' ')||
        rpad('event',35,' ')||rpad('ptext',35,' ')||rpad('p123',35,' ')||rpad('  Blocking_SID',15,' ')||rpad('Blocking_S#',15,' ')||rpad('cycle_flag',15,' ')||rpad('Program',30,' '));
        dbms_output.put_line(rpad('---',5,' ')||rpad('-----',10,' ')||rpad('----------',12,' ')||rpad('-------',12,' ')||rpad('------',20,' ')||
        rpad('-----',35,' ')||rpad('-----',35,' ')||rpad('----',35,' ')||rpad('  ------------',15,' ')||rpad('-----------',15,' ')||rpad('----------',15,' ')||rpad('-------',30,' '));
        dbms_output.put_line(rpad(b_rec.row_num,5,' ')||rpad(to_char(b_rec.rat_sum),10,' ')||rpad(to_char(b_rec.session_id),12,' ')||rpad(to_char(b_rec.session_serial#),12,' ')||rpad(nvl(b_rec.sql_id,' '),20,' ')||
        rpad(nvl(b_rec.event,' '),35,' ')||rpad(nvl(b_rec.ptext,' '),35,' ')||rpad(nvl(b_rec.p123,' '),35,' ')||rpad(nvl('  '||to_char(b_rec.blocking_session),' '),15,' ')||rpad(nvl(to_char(b_rec.blocking_session_serial#),' '),15,' ')
        ||rpad(b_rec.cycle_flag,15,' ')||rpad(b_rec.program,30,' '));
      else
        dbms_output.put_line(rpad(b_rec.row_num,5,' ')||rpad(to_char(b_rec.rat_sum),10,' ')||rpad(to_char(b_rec.session_id),12,' ')||rpad(to_char(b_rec.session_serial#),12,' ')||rpad(nvl(b_rec.sql_id,' '),20,' ')||
        rpad(nvl(b_rec.event,' '),35,' ')||rpad(nvl(b_rec.ptext,' '),35,' ')||rpad(nvl(b_rec.p123,' '),35,' ')||rpad(nvl('  '||to_char(b_rec.blocking_session),' '),15,' ')||rpad(nvl(to_char(b_rec.blocking_session_serial#),' '),15,' ')
        ||rpad(b_rec.cycle_flag,15,' ')||rpad(b_rec.program,30,' '));
      end if;
    end loop;
    dbms_output.new_line;
    dbms_output.new_line;
  end loop;
end;
/
spool off;