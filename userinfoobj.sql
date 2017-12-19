undefine source_schema
accept source_schema CHAR prompt           'schema list(a,b,c...): '  

SELECT count(*)
  FROM dba_tab_privs
 WHERE owner in upper('&&source_schema')
    or grantee in upper('&&source_schema');

SELECT '--' || owner || '.' || table_name || '  P:' || privilege "O",
       chr(10) || 'grant ' || privilege || ' on ' || owner || '.' ||
       table_name || ' to ' || grantee || case
         when grantable = 'YES' then
          ' with grant option'
         else
          null
       end || ';' p
  FROM dba_tab_privs
 WHERE owner in upper('&&source_schema')
    or grantee in upper('&&source_schema')
 order by grantee;
