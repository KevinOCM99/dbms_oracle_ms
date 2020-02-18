execute dbms_stats.gather_table_stats(ownname => 'TPCC', tabname => 'ORDERS', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE AUTO');
execute dbms_stats.gather_table_stats(ownname => 'TPCC', tabname => 'ORDER_LINE', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE AUTO');
create index TPCC.IDX$$_006C0001 on TPCC.CUSTOMER("C_LAST","C_D_ID","C_W_ID");
create index TPCC.IDX$$_006C0003 on TPCC.ORDERS("O_C_ID","O_D_ID","O_W_ID");
create index TPCC.IDX$$_006C0004 on TPCC.ORDER_LINE("OL_D_ID","OL_W_ID","OL_O_ID","OL_I_ID");
create index TPCC.IDX$$_006C0005 on TPCC.STOCK("S_W_ID","S_QUANTITY","S_I_ID");
create index TPCC.IDX$$_006C0006 on TPCC.CUSTOMER("C_LAST","C_D_ID","C_W_ID");
execute dbms_sqltune.create_sql_plan_baseline(task_name => 'STA_UPGRADE_TO_19C_CC', object_id => 15, owner_name => 'SYS', plan_hash_value => 1135310010);
execute dbms_sqltune.create_sql_plan_baseline(task_name => 'STA_UPGRADE_TO_19C_CC', object_id => 5, owner_name => 'SYS', plan_hash_value => 1135310010);

