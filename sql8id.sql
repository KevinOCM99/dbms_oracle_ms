---------------------------------------------------------------------------------
-- KnownFirst : SQL_ID                                                         --
-- ScriptName : sql_i2t.sql (SQL_ID->SQL_Full_Text) [V2]                       --
-- IntendedTo : Get SQL Full Text By Known SQL_ID                              --
-- DDictionay : GV$SQLAREA|DBA_HIST_SQLTEXT                                    --
-- Applicable : 11g                                                            --
-- CreationOn : 20140730                                                       --
-- RevisionOn : 20140731                                                       --
---------------------------------------------------------------------------------
ttitle off
clear columns breaks computes
set linesize 120 pagesize 80 heading off feedback off verify off wrap on
set buffer 9999 serveroutput on
column qtext format a120 heading "SQL Full Text"

accept sql_id prompt "Your SQL_ID? "

declare
   l_str long;
begin
   for x in (
      select coalesce((select sql_fulltext
                         from gv$sqlarea a
                        where rownum=1
                          and a.sql_id='&sql_id')
                     ,(select sql_text
                         from dba_hist_sqltext b
                        where b.sql_id='&sql_id'
                          and b.dbid=(select dbid from v$database))
                     ) as qtext
        from dual
      ) 
   loop
      l_str := dbms_lob.substr(x.qtext,32000,1);
      l_str := ltrim(regexp_replace(replace(replace(l_str,chr(10),' '),chr(13),' '),'( ){2,}','\1'));
      dbms_output.put_line(rpad('_',120,'_'));
      loop
         exit when l_str is null;
         dbms_output.put_line('>>>| '||rpad(substr(l_str,1,110),110,' ')||' |<<<');
         l_str := substr(l_str,110);
      end loop;
      dbms_output.put_line(rpad('^',120,'^'));
      exit;
   end loop;
end;
/

set heading on feedback 1
