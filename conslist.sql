REM ########################################################################
REM ##
REM ##   conslist.sql
REM ##
REM ##   Displays the foreign key relationships
REM ##
REM #######################################################################

CLEAR BREAK
CLEAR COL
SET LINES 200
SET PAGES 54
SET NEWPAGE 0
SET WRAP OFF
SET VERIFY OFF
SET FEEDBACK OFF

break on table_name skip 2 on constraint_name on r_table_name skip 1

column CHILDCOL format a30 head 'CHILD COLUMN'
column PARENTCOL format a30 head 'PARENT COLUMN'
column constraint_name format a20 head 'FK CONSTRAINT NAME'
column delete_rule format a15
column position format 99 heading Po
column bt noprint
column bo noprint

TTITLE LEFT _DATE CENTER 'FOREIGN KEY RELATIONSHIPS ON ' RIGHT 'PAGE:'FORMAT 999 SQL.PNO SKIP 2

ACCEPT OWNER_NAME PROMPT 'Enter Table Owner (or blank for all): '
ACCEPT PARENT_TABLE_NAME PROMPT 'Enter Parent Table or leave blank for all: '

with aa as
(
  select b.owner child_owner, b.table_name child_table ,  b.column_name child_column,
         b.position,
         c.owner parent_owner, c.table_name parent_table, c.column_name parent_column,
         a.constraint_name,
         a.delete_rule,
         b.table_name bt,
         b.owner bo
    from all_cons_columns b,
         all_cons_columns c,
         all_constraints a
   where b.constraint_name = a.constraint_name
     and a.owner           = b.owner
     and b.position        = c.position
     and c.constraint_name = a.r_constraint_name
     and c.owner           = a.r_owner
     and a.constraint_type = 'R'
     and c.owner      like case when upper('&OWNER_NAME') is null then '%'
                                else upper('&OWNER_NAME') end
     and c.table_name like case when upper('&PARENT_TABLE_NAME') is null then '%'
                                else upper('&PARENT_TABLE_NAME%') end
)
select child_owner || '.' || child_table || '.' || child_column CHILDCOL,
         position,
         parent_owner || '.' || parent_table || '.' || parent_column PARENTCOL,
         constraint_name,
         delete_rule,
         bt,
         bo
    from aa
order by 7,6,4,2
/
TTITLE OFF
SET FEEDBACK ON
SET VERIFY ON
CLEAR BREAK
CLEAR COL
SET PAGES 24
SET LINES 100
SET NEWPAGE 1
UNDEF OWNER
