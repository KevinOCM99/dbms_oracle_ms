ACCEPT SCHEMA PROMPT 'Table Owner: '
 ACCEPT TABNAME PROMPT 'Table Name:  '
 SELECT
  (SELECT SUM(S.BYTES)                                                                                               -- The Table Segment size
   FROM DBA_SEGMENTS S
   WHERE S.OWNER = UPPER('&SCHEMA') AND
        (S.SEGMENT_NAME = UPPER('&TABNAME'))) +
  (SELECT SUM(S.BYTES)                                                                                                 -- The Lob Segment Size
   FROM DBA_SEGMENTS S, DBA_LOBS L
   WHERE S.OWNER = UPPER('&SCHEMA') AND
        (L.SEGMENT_NAME = S.SEGMENT_NAME AND L.TABLE_NAME = UPPER('&TABNAME') AND L.OWNER = UPPER('&SCHEMA'))) +
  (SELECT SUM(S.BYTES)                                                                                                 -- The Lob Index size
   FROM DBA_SEGMENTS S, DBA_INDEXES I
   WHERE S.OWNER = UPPER('&SCHEMA') AND
        (I.INDEX_NAME = S.SEGMENT_NAME AND I.TABLE_NAME = UPPER('&TABNAME') AND INDEX_TYPE in ('NORMAL','LOB') AND I.OWNER = UPPER('&SCHEMA')))
   "TOTAL TABLE SIZE"
 FROM DUAL;