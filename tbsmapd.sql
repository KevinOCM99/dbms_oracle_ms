whenever sqlerror exit rollback
set feed on
set head on
set arraysize 1
set space 1
set verify off
set pages 100
set lines 120
set termout on
set serveroutput on size 1000000
undefine var_file_id
accept var_file_id number prompt           'file id: ' default 1


declare
  cursor c_map is
  (select file_id,block_id,blocks,'X' used
   from dba_extents where file_id=&&var_file_id
   union
   select file_id,block_id,blocks,'=' used
   from dba_free_space where file_id=&&var_file_id
   ) order by 1,2,3;
j number :=1;
bsize number;
begin
  select blocks/(120*120)  into bsize from dba_data_files where file_id=&&var_file_id;
  --that is display in 100 lines with linesize of 120  
       for r_map in c_map
       loop
           for i  in 1..r_map.blocks/bsize
           loop
            dbms_output.put(R_MAP.USED);
            if j>=120 then
        j :=1;dbms_output.new_line;
            else
               j := j+1;
            end if;
           end loop;
       end loop;
end;
/