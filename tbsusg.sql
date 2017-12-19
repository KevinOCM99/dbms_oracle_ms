col owner for a25
col object_name for a30
col object_type for a20
col tablespace_name for a30
col MB for 999999999
set lines 120

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

select *
  from (select owner, object_name, object_type, tablespace_name, MB
          from (select owner,
                       segment_name object_name,
                       segment_type object_type,
                       tablespace_name,
                       sum(bytes) / 1024 / 1024 MB
                  from dba_extents
                 where tablespace_name in
                       (SELECT * FROM TABLE(in_list('&tbslist')))
                 group by owner, segment_name, segment_type, tablespace_name) a
 order by MB desc, owner, object_name, object_type, tablespace_name) a
 where rownum < 20;

drop TYPE t_in_list_tab;
drop FUNCTION in_list;