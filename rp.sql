CREATE OR REPLACE FUNCTION RANDOM_PASSWORD (pwdLen number := 10)
   RETURN VARCHAR2
IS
   TEMP   VARCHAR2 (50);
   Step   number;
   Flag   number;--1 A--Z,2 a--z,3 0-9
   tmpChar varchar2(1);
BEGIN
   TEMP :='';
   for Step in 1..pwdLen loop
       if Step > 1 then
          Flag := ROUND (DBMS_RANDOM.VALUE (1,3));
       else
          Flag := ROUND (DBMS_RANDOM.VALUE (1,2));
       end if;
       --dbms_output.put_line(Flag);
       if flag = 1 then
          tmpChar := chr(64 + ROUND (DBMS_RANDOM.VALUE (1,26)));
       end if;
       if flag = 2 then
          tmpChar := chr(96 + ROUND (DBMS_RANDOM.VALUE (1,26)));
       end if;
       if flag = 3 then
          tmpChar := chr(47 + ROUND (DBMS_RANDOM.VALUE (1,10)));
       end if;
       --dbms_output.put_line(tmpChar);
       --
       TEMP := TEMP || tmpChar;
   end loop;
 
   RETURN TEMP;
END RANDOM_PASSWORD;
/
