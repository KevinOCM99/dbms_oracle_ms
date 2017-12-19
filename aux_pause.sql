accept opinion prompt 'Do you want to continue script execution? (Y/n) : ';
set newpage none
set termout  off
set verify   off
set heading  off
set feedback off
set pause    off
set echo     off
column a newline

spool p.sql

select decode(lower('&opinion'),'n','pause  Press <Ctrl>+<C> to quit current execution'
                                   ,'prompt Executing ...')
from dual;

spool off

set termout on
set heading  on
set feedback on

@p

set newpage 1
-------
--EOF--
-------
