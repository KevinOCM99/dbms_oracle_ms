COL STATUS FOR A15
SELECT GROUP#,SEQUENCE#,MEMBERS,STATUS,ARCHIVED, FIRST_CHANGE#, NEXT_CHANGE# 
FROM V$LOG
ORDER BY FIRST_CHANGE# DESC;

COL IS_RECOVERY_DEST_FILE HEADING INFRA FOR A6
COL MEMBER FOR A59
COL MEMBER_STATUS FOR A10 HEADING MEM_STATUS
COL GROUP_STATUS FOR A10 HEADING GRP_STATUS
SELECT M.GROUP#,M.TYPE,G.STATUS GROUP_STATUS,G.ARCHIVED,G.SEQUENCE#, G.FIRST_CHANGE# FIRST_SCN,NEXT_CHANGE# NEXT_SCN, M.STATUS MEMBER_STATUS,  M.IS_RECOVERY_DEST_FILE , M.MEMBER
FROM V$LOGFILE M ,V$LOG G
WHERE M.GROUP# = G.GROUP#
ORDER BY FIRST_CHANGE# DESC;


