set pages 999
ACCEPT wal_loc prompt 'Enter Wallet Location: '
!mv &wal_loc/cwallet.sso &wal_loc/cwallet.sso.orig
administer key management set keystore close;
administer key management set keystore open identified by "WelcomE__1234567" container=all;
administer key management set key identified by "WelcomE__1234567" with backup container=all;
administer key management create auto_login keystore from keystore '&wal_loc' identified by "WelcomE__1234567";
administer key management set keystore close identified by "WelcomE__1234567" container=all;
undefine wal_loc
