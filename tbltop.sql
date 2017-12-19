SET ECHO OFF TERMOUT ON LINESIZE 120 PAGESIZE 50 NEWPAGE 1 FEEDBACK 10 VERIFY OFF WRAP ON HEADING ON
----------------------------------------------------------------------------------------------------
-- FILE NAME  : TABLE_TOP.SQL                                                                     --
-- PARAMETER  : NONE                                                                              --
-- DEPENDENCY : N/A                                                                               --
-- CATEGORY   : QUERY / [FUNCTION] / WRAPPER / DISPATCHER / CONSTRUCTOR                           --
-- PURPOSE    : LIST LARGEST TABLES BY TOTAL SIZE ¨C INCLUDING SPACE USED BY INDEXES AND LOBS      --
-- SOURCE     : DBA_SEGMENTS ; DBA_INDEXES ; DBA_LOBS                                             --
-- TESTED     : 11G, 12C                                                                          --
-- CREATED    : 2015-08-15                                                                        --
-- REVISED    : 2015-08-15                                                                        --
-- LOCATION   : DBA\                                                                              --
-- CHANGE #1  : 2015-08-15                                                                        --
----------------------------------------------------------------------------------------------------

---------------
-- PARAMETER --
---------------
ACCEPT TS PROMPT "TABLESPACE [OPTIONAL]  : "
ACCEPT OW PROMPT "SCHEMA     [OPTIONAL]  : "
ACCEPT TN PROMPT "TOP NUMBER [MANDATORY] : "

-----------
-- TITLE --
-----------
prompt .....................
prompt > TOP TABLE BY SIZE <
prompt ^^^^^^^^^^^^^^^^^^^^^

-------------
-- COLUMNS --
-------------
column schema_name     format a25 heading "SCHEMA|NAME"
column table_name      format a30 heading "TABLE|NAME"
column tablespace_name format a25 heading "TABLESPACE|NAME"
column space_usage     format a12 heading "SPACE|ALLOCATED" justify right
column percentage      format a10 heading "SPACE|RATIO"     justify right

----------
-- BODY --
----------
with segment_rollup as (
  select owner
       , table_name
       , tablespace_name
       , owner                      as segment_owner
       , table_name                 as segment_name
    from dba_tables
    union all
  select table_owner                as owner
       , table_name
       , tablespace_name
       , owner                      as segment_owner
       , index_name                 as segment_name
    from dba_indexes
    union all
  select owner
       , table_name
       , tablespace_name
       , owner                      as segment_owner
       , segment_name
    from dba_lobs
    union all
  select owner
       , table_name
       , tablespace_name
       , owner                      as segment_owner
       , index_name                 as segment_name
    from dba_lobs
), segment_size as (
select r.owner                                  as schema_name
     , r.table_name                             as table_name
     , nvl(r.tablespace_name,s.tablespace_name) as tablespace_name
     , round(sum(s.bytes)/1024/1024)            as size_mb
     , ratio_to_report(sum(s.bytes))over()*100  as r2r
  from segment_rollup r
  left outer join dba_segments s
               on r.segment_owner = s.owner
              and r.segment_name = s.segment_name
 where 1 = 1
   and s.owner = nvl(upper(trim('&ow')),s.owner)
   and s.tablespace_name = nvl(upper(trim('&ts')),s.tablespace_name)
 group by r.owner
        , r.table_name
        , nvl(r.tablespace_name,s.tablespace_name)
 --order by size_mb desc
), ranked_tables as (
select rank() over (order by sum(size_mb) desc)                              as top_number
     , schema_name                                                           as schema_name
     , table_name                                                            as table_name
     , listagg(tablespace_name,', ') within group (order by tablespace_name) as tablespace_name
     , lpad(sum(size_mb),9,' ')||' MB'                                       as space_usage
     , lpad(to_char(round(sum(r2r),2),'FM99.00'),8,' ')||' %'                as percentage
  from segment_size
 where 1=1
 --and rownum<10
 group by schema_name
        , table_name
having sum(size_mb) >= 100
)
select schema_name
     , table_name
     , tablespace_name
     , space_usage
     , percentage
  from ranked_tables
 where top_number <= &tn
 --order by sum(size_mb)
 order by schema_name
        , table_name
/

--------------
-- TEARDOWN --
--------------
UNDEFINE TS OW TN
---------
-- EOF --
---------
