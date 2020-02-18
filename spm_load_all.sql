SET SERVEROUT ON
SET PAGESIZE 1000
SET LONG 2000000
SET LINESIZE 400


DECLARE

l_plans_loaded  PLS_INTEGER;

BEGIN

  l_plans_loaded := DBMS_SPM.load_plans_from_sqlset(
                       sqlset_name  => 'STS_CaptureCursorCache',
                       fixed        => 'YES',
                       enabled      => 'YES'
                       );

END;
/
