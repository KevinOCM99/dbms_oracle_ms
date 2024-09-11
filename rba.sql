
CREATE OR REPLACE FUNCTION getbfno (p_dba IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_str   VARCHAR2 (255) DEFAULT NULL;
   l_fno   VARCHAR2 (15);
   l_bno   VARCHAR2 (15);
BEGIN
   l_fno :=
      DBMS_UTILITY.data_block_address_file (TO_NUMBER (LTRIM (p_dba, '0x'),
                                                       'xxxxxxxx'
                                                      )
                                           );
   l_bno :=
      DBMS_UTILITY.data_block_address_block (TO_NUMBER (LTRIM (p_dba, '0x'),
                                                        'xxxxxxxx'
                                                       )
                                            );
   l_str :=
         'datafile# is:'
      || l_fno
      || CHR (10)
      || 'datablock is:'
      || l_bno
      || CHR (10)
      || 'dump command:alter system dump datafile '
      || l_fno
      || ' block '
      || l_bno
      || ';';
   RETURN l_str;
END;
/

select getbfno('&1') BFNO from dual;
