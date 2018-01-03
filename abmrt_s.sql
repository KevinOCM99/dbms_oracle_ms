!dd of=/u01/app/oracle/oradata/my11gsb/tbs_test01.dbf bs=8192 seek=131 conv=notrunc count=1 if=/dev/zero
--we can see 1 block corruption
!dbv file='/u01/app/oracle/oradata/my11gsb/tbs_test01.dbf' blocksize=8192
--this will trigger the ambr process, we can see it from alert log
alter system flush buffer_cache;
select * from testbmr;
