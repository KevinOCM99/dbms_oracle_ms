drop tablespace tbs_test including contents and datafiles;
create tablespace tbs_test datafile '/u01/app/oracle/oradata/my11g/tbs_test01.dbf' size 10m autoextend on;
create table testbmr tablespace tbs_test as select 1 id from dual ;
select distinct  dbms_rowid.rowid_block_number(rowid) from testbmr;
alter system flush buffer_cache;
alter system switch logfile;
@dg
