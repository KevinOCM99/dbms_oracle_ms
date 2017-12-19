column name for a30
column value for a30
column Session_Modifiable for a7  heading "Session"
column System_Modifiable   for a6  heading "System"
column Instance_Modifiable  for a8 heading "Instance"
column Modified  for a8 heading "Modified"
SELECT name, value ,    
       (CASE WHEN ISSES_MODIFIABLE = 'TRUE' THEN 'Yes'
         ELSE 'No' END) AS Session_Modifiable,
       (CASE WHEN ISSYS_MODIFIABLE = 'IMMEDIATE' THEN 'Imme'
         WHEN ISSYS_MODIFIABLE = 'DEFERRED' THEN 'Next'
         ELSE 'No' END) AS System_Modifiable,
       (CASE WHEN ISINSTANCE_MODIFIABLE = 'TRUE' THEN 'Yes'
         ELSE 'No' END) AS Instance_Modifiable,  
       (CASE WHEN ISMODIFIED = 'MODIFIED' THEN 'Yes'
         ELSE 'No' END) AS Modified
FROM v$parameter
where upper(name) like upper('%&name%')
ORDER BY name;
