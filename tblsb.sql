ACCEPT SCHEMA PROMPT 'Table Owner: '
ACCEPT TABNAME PROMPT 'Table Name:  '
col "TOTAL TABLE SIZE" for 9999999999999999
 SELECT
  (SELECT SUM(S.BYTES)                                                                                                 -- The Table Segment size
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
        (I.INDEX_NAME = S.SEGMENT_NAME AND I.TABLE_NAME = UPPER('&TABNAME') AND INDEX_TYPE = 'LOB' AND I.OWNER = UPPER('&SCHEMA')))
   "TOTAL TABLE SIZE"
 FROM DUAL;

col "Table Size" for 999999999999999
SELECT SUM(S.BYTES)  "Table Size" -- The Table Segment size
FROM DBA_SEGMENTS S
WHERE S.OWNER = UPPER('&SCHEMA') AND
(S.SEGMENT_NAME = UPPER('&TABNAME'));

col "Blob Size" for 999999999999999
SELECT SUM(S.BYTES)  "Blob Size"   -- The Lob Segment Size
FROM DBA_SEGMENTS S, DBA_LOBS L
WHERE S.OWNER = UPPER('&SCHEMA') AND
(L.SEGMENT_NAME = S.SEGMENT_NAME 
AND L.TABLE_NAME = UPPER('&TABNAME') 
AND L.OWNER = UPPER('&SCHEMA'));

col "Lob Index Size" for 999999999999999
SELECT SUM(S.BYTES)  "Lob Index Size" -- The Lob Index size
FROM DBA_SEGMENTS S, DBA_INDEXES I
WHERE S.OWNER = UPPER('&SCHEMA') 
AND (I.INDEX_NAME = S.SEGMENT_NAME 
AND I.TABLE_NAME = UPPER('&TABNAME') 
AND INDEX_TYPE = 'LOB' 
AND I.OWNER = UPPER('&SCHEMA'));
