SET ECHO OFF TERMOUT ON LINESIZE 120 PAGESIZE 50 VERIFY OFF WRAP ON HEADING ON FEEDBACK 10
----------------------------------------------------------------------------------------------------
-- NAME      : TABLE_SIZE.SQL                                                                     --
-- PURPOSE   : TABLE SIZE BREAKDOWN                                                               --
-- CATEGORY  : QUERY / [FUNCTION] / WRAPPER / DISPATCHER / CONSTRUCTOR                            --
-- SOURCE    : DBA_TABLES ; DBA_SEGMENTS ; DBA_INDEXES ; DBA_LOBS                                 --
-- COMPONENT : NONE                                                                               --
-- PARAMETER : 1) TABLE OWNER                                                                     --
--             2) TABLE NAME                                                                      --
-- TESTED    : 11G, 12C                                                                           --
-- CREATED   : 2015-07-04                                                                         --
-- REVISED   : 2015-07-16                                                                         --
-- LOCATION  : DBA\CORE\OBJECT\TABLE                                                              --
-- CAHNGE #1 : 2015-08-15, INVOLVE SPACE USED BY INDEXES AND LOBS                                 --
----------------------------------------------------------------------------------------------------
SET NEWPAGE NONE FEEDBACK OFF COLSEP ' '
---------------
-- PARAMETER --
---------------
ACCEPT TABLE_OWNER PROMPT "TABLE OWNER [MANDATORY]: "
ACCEPT TABLE_NAME  PROMPT "TABLE NAME  [MANDATORY]: "

-----------
-- TITLE --
-----------
PROMPT ..............    ....................................................................
PROMPT > TOTAL SIZE <    > MAIN SOURCE : DBA_SEGMENTS ; DBA_TABLES ; DBA_INDEXES ; DBA_LOBS <
PROMPT ^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

------------
-- COLUMN --
------------
column tablespace_name format a15     heading "TABLESPACE|NAME"
column segment_owner   format a20     heading "SEGMENT|OWNER"
column segment_name    format a30     heading "SEGMENT|NAME "
column segment_type    format a12     heading "SEGMENT|TYPE"
column object_type     format a16     heading "OBJECT|TYPE"
column num_rows        format a09     heading "NUM|ROWS"          justify right
column last_analyzed   format a20     heading "LAST|ANALYZED"	noprint
column segment_size    format 999999  heading "SEGMENT|SIZE(MB)"  justify right
----------------------------------------------------------------------------------------------
COLUMN DUMMY NOPRINT
COMPUTE SUM OF segment_size ON DUMMY
BREAK ON DUMMY

-----------
-- QUERY --
-----------
select null dummy
     , tablespace_name
     , segment_owner
     , segment_name
     , segment_type
     , object_type
     , num_rows
     , last_analyzed
   --, lpad(round(sum(extent_size)/1024/1024),6,' ')||' MB' as segment_size
     , round(sum(extent_size)/1024/1024)                    as segment_size
  from ( select 1                                                as order_id
              , s.tablespace_name                                as tablespace_name
              , s.owner                                          as segment_owner
              , s.segment_name                                   as segment_name
              , s.segment_type                                   as segment_type
              , nvl(t.iot_type,'HEAP-ORGANIZED')                 as object_type
              , lpad(t.num_rows,12,' ')                          as num_rows
              , to_char(t.last_analyzed,'yyyy-mm-dd hh24:mi:ss') as last_analyzed
              , s.bytes                                          as extent_size
           from dba_segments s
           left outer join dba_tables t
                        on s.owner = t.owner
                       and s.segment_name = t.table_name
          where 1 = 1
            and s.segment_name = upper(trim('&table_name'))
            and s.owner = nvl(upper(trim('&table_owner')),s.owner)
            and s.segment_type like 'TABLE%'
          union all
         select 2                                                as order_id
              , s.tablespace_name                                as tablespace_name
              , s.owner                                          as segment_owner
              , s.segment_name                                   as segment_name
              , s.segment_type                                   as segment_type
              , decode(i.index_type,'NORMAL','B-TREE'
                                            ,i.index_type)       as object_type
              , lpad(i.num_rows,12,' ')                          as num_rows
              , to_char(i.last_analyzed,'yyyy-mm-dd hh24:mi:ss') as last_analyzed
              , s.bytes                                          as extent_size
           from dba_segments s
           left outer join dba_indexes i
                        on s.owner = i.owner
                       and s.segment_name = i.index_name
          where 1 = 1
            and i.table_name = upper(trim('&table_name'))
            and i.table_owner = nvl(upper(trim('&table_owner')),i.table_owner)
            and s.segment_type like 'INDEX%'
          union all
         select 3                                           as order_id
              , s.tablespace_name                           as tablespace_name
              , s.owner                                     as segment_owner
              , s.segment_name                              as segment_name
              , s.segment_type                              as segment_type
              , 'LOB'                                       as object_type
              , lpad('-',12,' ')                            as num_rows
              , '-'                                         as last_analyzed
              , s.bytes                                     as extent_size
           from dba_segments s
           left outer join dba_lobs l
                        on s.owner = l.owner
                       and s.segment_name = l.segment_name
          where 1 = 1
            and l.table_name = upper(trim('&table_name'))
            and l.owner = nvl(upper(trim('&table_owner')),l.owner)
            and s.segment_type like 'LOB%'
          union all
         select 4                                           as order_id
              , s.tablespace_name                           as tablespace_name
              , s.owner                                     as segment_owner
              , s.segment_name                              as segment_name
              , s.segment_type                              as segment_type
              , 'LOBINDEX'                                  as object_type
              , lpad('-',12,' ')                            as num_rows
              , '-'                                         as last_analyzed
              , s.bytes                                     as extent_size
           from dba_segments s
           left outer join dba_lobs l
                        on s.owner = l.owner
                       and s.segment_name = l.INDEX_NAME
          where 1 = 1
            and l.table_name = upper(trim('&table_name'))
            and l.owner = nvl(upper(trim('&table_owner')),l.owner)
            and s.segment_type like 'LOB%'
       )
 group by order_id
        , tablespace_name
        , segment_owner
        , segment_name
        , segment_type
        , object_type
        , num_rows
        , last_analyzed
 order by order_id
        , segment_owner
        , segment_name
/

-----------
-- TITLE --
-----------
PROMPT ..............    ..........................................
PROMPT > TABLE SIZE <    > SOURCE : DBMS_SPACE.OBJECT_SPACE_USAGE <
PROMPT ^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

------------
-- PL/SQL --
------------
SET SERVEROUTPUT ON FORMAT WRAPPED FEEDBACK OFF

declare
  su number;
  sa number;
  pn varchar2(20);
begin
  dbms_space.object_space_usage(upper('&table_owner'),upper('&table_name'),'TABLE',0.0,su,sa,pn);
  dbms_output.put_line('  SPACE ALLOCATED |  SPACE REAL-USED');
  dbms_output.put_line(' ---------------- | ----------------');
  dbms_output.put_line(lpad(round(sa/1024/1024),14,' ')||' MB | '||lpad(round(su/1024/1024),13,' ')||' MB ');
end;
/

SET SERVEROUTPUT OFF FEEDBACK ON
PROMPT
--------------
-- TEARDOWN --
--------------
UNDEFINE TABLE_OWNER TABLE_NAME
SET NEWPAGE 1 COLSEP '|'

---------
-- EOF --
---------
