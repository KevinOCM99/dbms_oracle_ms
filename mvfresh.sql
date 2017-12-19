col owner for a15;
col mview_name for a35;
col fullrefreshtim for 99999999 heading FULLTIME;
col increfreshtim for 99999999 heading INCRTIME;
SELECT owner,
   mview_name,
   last_refresh_date "START_TIME",
   CASE
      WHEN fullrefreshtim <> 0 THEN
         LAST_REFRESH_DATE + fullrefreshtim/60/60/24
      WHEN increfreshtim <> 0 THEN
         LAST_REFRESH_DATE + increfreshtim/60/60/24
      ELSE
         LAST_REFRESH_DATE
   END "END_TIME",
   fullrefreshtim,
   increfreshtim
FROM dba_mview_analysis
where owner like upper('&owner%')
and mview_name like upper('&mv%')
order by 1,2;