col owner for a20
col oname for a20
col otype for a20
col tablespace_name for a25
col MB for 999999999

CREATE OR REPLACE TYPE t_in_list_tab AS TABLE OF VARCHAR2 (4000);
/

CREATE OR REPLACE FUNCTION in_list (p_in_list  IN  VARCHAR2)
  RETURN t_in_list_tab
AS
  l_tab   t_in_list_tab := t_in_list_tab();
  l_text  VARCHAR2(32767) := p_in_list || ',';
  l_idx   NUMBER;
BEGIN
  LOOP
    l_idx := INSTR(l_text, ',');
    EXIT WHEN NVL(l_idx, 0) = 0;
    l_tab.extend;
    l_tab(l_tab.last) := upper(TRIM(SUBSTR(l_text, 1, l_idx - 1)));
    l_text := SUBSTR(l_text, l_idx + 1);
  END LOOP;

  RETURN l_tab;
END;
/


with basicresult as
     (
      select owner,
           segment_name object_name,
           segment_type object_type,
           tablespace_name,
           sum(bytes) / 1024 / 1024 MB
      from dba_extents
      where owner in
           (SELECT * FROM TABLE(in_list('&schemalist')))
      group by owner, segment_name, segment_type, tablespace_name
     )
select  OWNER,TABLESPACE_NAME, oname, otype, MB
from (
select 1 ord, OWNER,TABLESPACE_NAME,OBJECT_NAME oname,OBJECT_TYPE otype,MB
from(     
select *
from basicresult
order by MB desc)
where rownum < 20
union all     
select 2 ord, owner,tablespace_name,'--tbs--' oname,'--tbs--' oname,sum(MB) MB
from basicresult
group by owner,tablespace_name
) a
order by ord, MB desc,owner,tablespace_name,oname,otype;

drop TYPE t_in_list_tab;
drop FUNCTION in_list;


