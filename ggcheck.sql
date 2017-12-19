---------------------------------------------------------------------------------
-- KnownFirst : Nothing                                                        --
-- ScriptName : gg_lag.sql                                                     --
-- IntendedTo : GoldenGate Heartbeat Lag                                       --
-- Features 1 : table_name  like '%HEARTBEAT%'                                 --
-- Features 2 : column_name like '%TIMESTAMP%'                                 --
-- Features 3 : data_type   like 'DATE' or 'TIMESTAMP%'                        --
-- Applicable : 11g                                                            --
-- CreationOn : 20140502                                                       --
-- RevisionOn : 20140513 Using column max length to format output.             --
---------------------------------------------------------------------------------
@login
set verify       off
set termout      on
set feedback     off
set linesize     200
set pagesize     0
set trimspool    on
set serveroutput on format WORD_WRAPPED

declare
  cursor c_hb is
  select t.owner
     --, lpad(decode(sign(length(t.owner)-15),1,substr(t.owner,1,13)||'..',t.owner),15,' ') as owner_short
       , length(t.owner) as owner_length
       , t.table_name
       , c.column_name
       , substr(c.data_type,1,9) as data_type
    from dba_tables t left outer join dba_tab_columns c on t.owner=c.owner and t.table_name=c.table_name
   where c.column_name like '%TIMESTAMP%'
     and substr(c.data_type,1,9) in ('DATE','TIMESTAMP')
     and t.table_name like '%HEARTBEAT%'
     and t.status='VALID'
   order by t.owner
  ;
  v_record            number;
  v_owner             varchar2(30);
  v_text              varchar2(2000);
  v_lag               varchar2(20);
  v_time              varchar2(19);
  v_gmt2bst           varchar2(19);
  v_owner_max_len     number;
begin
  v_owner_max_len:=0;
  select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') into v_time from dual;
  dbms_output.put_line(chr(10)||'Now: '||v_time);
  /* 1st Loop */
  for v in c_hb loop
    v_text:='select count(*) from '||v.owner||'.'||v.table_name;
    execute immediate v_text into v_record;
    if v_record=1 then
      if v_owner_max_len<v.owner_length then
         v_owner_max_len:=v.owner_length;
      end if;
    end if;
  end loop;
  /* 2nd Loop */
  for v in c_hb loop
    v_text:='select count(*) from '||v.owner||'.'||v.table_name;
    execute immediate v_text into v_record;
    if v_record=1 then
      if v.data_type='DATE' then
        v_text:='';
        v_text:=v_text||'with a as ( /* Convert GMT timestamp into British Summer Time */'
             ||chr(10)||'select case when ('||v.column_name||' between next_day(last_day(to_date(''01-03'',''DD-MM''))-7,''Sunday'')'
             ||chr(10)||'        and next_day(last_day(to_date(''01-10'',''DD-MM''))-7,''Sunday''))'
             ||chr(10)||'       then '||v.column_name||'+to_dsinterval(''0 01:00:00'')'
             ||chr(10)||'       else '||v.column_name||' end as gmt2bst_time'
             ||chr(10)||'  from '||v.owner||'.'||v.table_name
             ||chr(10)||'),   b as ('
             ||chr(10)||'select to_char(sysdate,''yyyy-mm-dd hh24:mi:ss'')        as system_timestamp'
             ||chr(10)||'     , to_char(gmt2bst_time,''yyyy-mm-dd hh24:mi:ss'')   as heartbeat_timestamp'
             ||chr(10)||'     , round(to_number(sysdate-gmt2bst_time)*24*60*60)   as sec'
           --||chr(10)||'     , extract(day from 24*60*60*(sysdate-gmt2bst_time)) as sec'
             ||chr(10)||'  from a'
             ||chr(10)||')'
             ||chr(10)||'select system_timestamp'
             ||chr(10)||'     , lpad('
             ||chr(10)||'       decode(sign(sec),-1,''-''||'
             ||chr(10)||'       to_char(trunc(abs(sec)/3600),''FM99999900'')||'':''||'
             ||chr(32)||'       to_char(trunc(mod(abs(sec),3600)/60),''FM00'')||'':''||'
             ||chr(10)||'       to_char(mod(abs(sec),60),''FM00'')'
             ||chr(10)||'      ,to_char(trunc(sec/3600),''FM99999900'')||'':''||'
             ||chr(10)||'       to_char(trunc(mod(sec,3600)/60),''FM00'')||'':''||'
             ||chr(10)||'       to_char(mod(sec,60),''FM00''))'
             ||chr(10)||'       ,15,'' '') as lag'
             ||chr(10)||'  from b';
      else
        v_text:='';
        v_text:=v_text||'with a as ( /* Convert GMT timestamp into British Summer Time */'
             ||chr(10)||'select case when ('||v.column_name||' between next_day(last_day(to_date(''01-03'',''DD-MM''))-7,''Sunday'')'
             ||chr(10)||'        and next_day(last_day(to_date(''01-10'',''DD-MM''))-7,''Sunday''))'
             ||chr(10)||'       then '||v.column_name||'+to_dsinterval(''0 01:00:00'')'
             ||chr(10)||'       else '||v.column_name||' end as gmt2bst_time'
             ||chr(10)||'  from '||v.owner||'.'||v.table_name
             ||chr(10)||'),   b as ('
             ||chr(10)||'select to_char(sysdate,''yyyy-mm-dd hh24:mi:ss'')        as system_timestamp'
             ||chr(10)||'     , to_char(gmt2bst_time,''yyyy-mm-dd hh24:mi:ss'')   as heartbeat_timestamp'
           --||chr(10)||'     , round(to_number(sysdate-gmt2bst_time)*24*60*60)   as sec'
             ||chr(10)||'     , extract(day from 24*60*60*(sysdate-gmt2bst_time)) as sec'
             ||chr(10)||'  from a'
             ||chr(10)||')'
             ||chr(10)||'select system_timestamp'
             ||chr(10)||'     , lpad('
             ||chr(10)||'       decode(sign(sec),-1,''-''||'
             ||chr(10)||'       to_char(trunc(abs(sec)/3600),''FM99999900'')||'':''||'
             ||chr(32)||'       to_char(trunc(mod(abs(sec),3600)/60),''FM00'')||'':''||'
             ||chr(10)||'       to_char(mod(abs(sec),60),''FM00'')'
             ||chr(10)||'      ,to_char(trunc(sec/3600),''FM99999900'')||'':''||'
             ||chr(10)||'       to_char(trunc(mod(sec,3600)/60),''FM00'')||'':''||'
             ||chr(10)||'       to_char(mod(sec,60),''FM00''))'
             ||chr(10)||'       ,15,'' '') as lag'
             ||chr(10)||'  from b';
      end if;
    --dbms_output.put_line(v_text);
      execute immediate v_text into v_gmt2bst, v_lag;
    --dbms_output.put_line('Now: '||v_gmt2bst);
    --dbms_output.put_line('Lag: '||v_lag||' @ '||lpad(v.owner,30,' ')||'.'||v.table_name);
    --dbms_output.put_line('Lag: '||v_lag||' @ '||v.owner_short||'.'||v.table_name);
      dbms_output.put_line('Lag: '||v_lag||' @ '||lpad(v.owner,v_owner_max_len,' ')||'.'||v.table_name);
    end if;
  end loop;
end;
/
undefine v_owner
undefine v_text
undefine v_lag
undefine v_time
undefine v_gmt2bst
--EOF
