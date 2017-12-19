--------------------------------------------------------------------------------
-- Ask4 : none                                                                --
-- Name : os_stat.sql                                                         --
-- Todo : What privileges(role/system/table) does a role have?                --
-- View : v$OSStat                                                            --
-- Tool : none                                                                --
-- Base : 11g                                                                 --
-- Born : 20150123                                                            --
-- Fix1 : 20150123                                                            --
-- Path : FIL-DBA/Performace/TOP                                              --
--------------------------------------------------------------------------------

prompt ..........................
prompt > SELECT * FROM V$OSSTAT <
prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^

clear columns breaks computes

column stat_ord  format 99        heading "Ord"
column stat_name format a24       heading "Stat_Name"
column category  format a08       heading "Category"
column value     format 999999999 heading "Value"
column unit      format a06       heading "Unit"
column comments  format a50       heading "Comment" truncated
column type      format a10

select decode(stat_name,'LOAD'                      , 1
                       ,'NUM_CPU_CORES'             , 2
                       ,'NUM_CPU_SOCKETS'           , 3
                       ,'NUM_CPUS'                  , 4
                       ,'IDLE_TIME'                 , 5
                       ,'BUSY_TIME'                 , 6
                       ,'USER_TIME'                 , 7
                       ,'SYS_TIME'                  , 8
                       ,'IOWAIT_TIME'               , 9
                       ,'NICE_TIME'                 ,10
                       ,'RSRC_MGR_CPU_WAIT_TIME'    ,11
                       ,'PHYSICAL_MEMORY_BYTES'     ,12
                       ,'VM_IN_BYTES'               ,13
                       ,'VM_OUT_BYTES'              ,14
                       ,'TCP_SEND_SIZE_MIN'         ,15
                       ,'TCP_SEND_SIZE_DEFAULT'     ,16
                       ,'TCP_SEND_SIZE_MAX'         ,17
                       ,'TCP_RECEIVE_SIZE_MIN'      ,18
                       ,'TCP_RECEIVE_SIZE_DEFAULT'  ,19
                       ,'TCP_RECEIVE_SIZE_MAX'      ,20
                       ,'GLOBAL_SEND_SIZE_MAX'      ,21
                       ,'GLOBAL_RECEIVE_SIZE_MAX'   ,22
                       ,99) as stat_ord
     , decode(stat_name,'LOAD'                      ,'LOAD'
                       ,'NUM_CPU_CORES'             ,'NUM_CPU_CORES'           
                       ,'NUM_CPU_SOCKETS'           ,'NUM_CPU_SOCKETS'         
                       ,'NUM_CPUS'                  ,'NUM_CPUS'                
                       ,'IDLE_TIME'                 ,'IDLE_TIME'               
                       ,'BUSY_TIME'                 ,'BUSY_TIME'               
                       ,'USER_TIME'                 ,'USER_TIME'               
                       ,'SYS_TIME'                  ,'SYS_TIME'                
                       ,'IOWAIT_TIME'               ,'IOWAIT_TIME'             
                       ,'NICE_TIME'                 ,'NICE_TIME'               
                       ,'RSRC_MGR_CPU_WAIT_TIME'    ,'RSRC_MGR_CPU_WAIT_TIME'  
                       ,'PHYSICAL_MEMORY_BYTES'     ,'PHYSICAL_MEMORY_SIZE'   
                       ,'VM_IN_BYTES'               ,'VM_IN'             
                       ,'VM_OUT_BYTES'              ,'VM_OUT'            
                       ,'TCP_SEND_SIZE_MIN'         ,'TCP_SEND_SIZE_MIN'       
                       ,'TCP_SEND_SIZE_DEFAULT'     ,'TCP_SEND_SIZE_DEFAULT'   
                       ,'TCP_SEND_SIZE_MAX'         ,'TCP_SEND_SIZE_MAX'       
                       ,'TCP_RECEIVE_SIZE_MIN'      ,'TCP_RECEIVE_SIZE_MIN'    
                       ,'TCP_RECEIVE_SIZE_DEFAULT'  ,'TCP_RECEIVE_SIZE_DEFAULT'
                       ,'TCP_RECEIVE_SIZE_MAX'      ,'TCP_RECEIVE_SIZE_MAX'    
                       ,'GLOBAL_SEND_SIZE_MAX'      ,'GLOBAL_SEND_SIZE_MAX'    
                       ,'GLOBAL_RECEIVE_SIZE_MAX'   ,'GLOBAL_RECEIVE_SIZE_MAX' 
                       ,'?') as stat_name
     , decode(stat_name,'LOAD'                      ,'LOAD'
                       ,'NUM_CPU_CORES'             ,'CPU'
                       ,'NUM_CPU_SOCKETS'           ,'CPU'
                       ,'NUM_CPUS'                  ,'CPU'
                       ,'IDLE_TIME'                 ,'CPU'
                       ,'BUSY_TIME'                 ,'CPU'
                       ,'USER_TIME'                 ,'CPU'
                       ,'SYS_TIME'                  ,'CPU'
                       ,'IOWAIT_TIME'               ,'CPU'
                       ,'NICE_TIME'                 ,'CPU'
                       ,'RSRC_MGR_CPU_WAIT_TIME'    ,'CPU'
                       ,'PHYSICAL_MEMORY_BYTES'     ,'MEMORY'
                       ,'VM_IN_BYTES'               ,'MEMORY'
                       ,'VM_OUT_BYTES'              ,'MEMORY'
                       ,'TCP_SEND_SIZE_MIN'         ,'NETWORK'
                       ,'TCP_SEND_SIZE_DEFAULT'     ,'NETWORK'
                       ,'TCP_SEND_SIZE_MAX'         ,'NETWORK'
                       ,'TCP_RECEIVE_SIZE_MIN'      ,'NETWORK'
                       ,'TCP_RECEIVE_SIZE_DEFAULT'  ,'NETWORK'
                       ,'TCP_RECEIVE_SIZE_MAX'      ,'NETWORK'
                       ,'GLOBAL_SEND_SIZE_MAX'      ,'NETWORK'
                       ,'GLOBAL_RECEIVE_SIZE_MAX'   ,'NETWORK'
                       ,'?') as category
     , decode(stat_name,'LOAD'                      ,value
                       ,'NUM_CPU_CORES'             ,value
                       ,'NUM_CPU_SOCKETS'           ,value
                       ,'NUM_CPUS'                  ,value
                       ,'IDLE_TIME'                 ,round(value/100)
                       ,'BUSY_TIME'                 ,round(value/100)
                       ,'USER_TIME'                 ,round(value/100)
                       ,'SYS_TIME'                  ,round(value/100)
                       ,'IOWAIT_TIME'               ,round(value/100)
                       ,'NICE_TIME'                 ,round(value/100)
                       ,'RSRC_MGR_CPU_WAIT_TIME'    ,round(value/100)
                       ,'PHYSICAL_MEMORY_BYTES'     ,round(value/1024/1024/1024)
                       ,'VM_IN_BYTES'               ,round(value/1024/1024)
                       ,'VM_OUT_BYTES'              ,round(value/1024/1024)
                       ,'TCP_SEND_SIZE_MIN'         ,round(value/1024)
                       ,'TCP_SEND_SIZE_DEFAULT'     ,round(value/1024)
                       ,'TCP_SEND_SIZE_MAX'         ,round(value/1024)
                       ,'TCP_RECEIVE_SIZE_MIN'      ,round(value/1024)
                       ,'TCP_RECEIVE_SIZE_DEFAULT'  ,round(value/1024)
                       ,'TCP_RECEIVE_SIZE_MAX'      ,round(value/1024)
                       ,'GLOBAL_SEND_SIZE_MAX'      ,round(value/1024)
                       ,'GLOBAL_RECEIVE_SIZE_MAX'   ,round(value/1024)
                       ,'?') as value
     , decode(stat_name,'LOAD'                      ,'Number'
                       ,'NUM_CPU_CORES'             ,'Number'
                       ,'NUM_CPU_SOCKETS'           ,'Number'
                       ,'NUM_CPUS'                  ,'Number'
                       ,'IDLE_TIME'                 ,'Second'
                       ,'BUSY_TIME'                 ,'Second'
                       ,'USER_TIME'                 ,'Second'
                       ,'SYS_TIME'                  ,'Second'
                       ,'IOWAIT_TIME'               ,'Second'
                       ,'NICE_TIME'                 ,'Second'
                       ,'RSRC_MGR_CPU_WAIT_TIME'    ,'Second'
                       ,'PHYSICAL_MEMORY_BYTES'     ,'GB'
                       ,'VM_IN_BYTES'               ,'MB'
                       ,'VM_OUT_BYTES'              ,'MB'
                       ,'TCP_SEND_SIZE_MIN'         ,'KB'
                       ,'TCP_SEND_SIZE_DEFAULT'     ,'KB'
                       ,'TCP_SEND_SIZE_MAX'         ,'KB'
                       ,'TCP_RECEIVE_SIZE_MIN'      ,'KB'
                       ,'TCP_RECEIVE_SIZE_DEFAULT'  ,'KB'
                       ,'TCP_RECEIVE_SIZE_MAX'      ,'KB'
                       ,'GLOBAL_SEND_SIZE_MAX'      ,'KB'
                       ,'GLOBAL_RECEIVE_SIZE_MAX'   ,'KB'
                       ,'?') as unit
     , decode(stat_name,'LOAD'                      ,'Current'
                       ,'NUM_CPU_CORES'             ,'Constant'
                       ,'NUM_CPU_SOCKETS'           ,'Constant'
                       ,'NUM_CPUS'                  ,'Constant'
                       ,'IDLE_TIME'                 ,'Cumulated'
                       ,'BUSY_TIME'                 ,'Cumulated'
                       ,'USER_TIME'                 ,'Cumulated'
                       ,'SYS_TIME'                  ,'Cumulated'
                       ,'IOWAIT_TIME'               ,'Cumulated'
                       ,'NICE_TIME'                 ,'Cumulated'
                       ,'RSRC_MGR_CPU_WAIT_TIME'    ,'Cumulated'
                       ,'PHYSICAL_MEMORY_BYTES'     ,'Constant'
                       ,'VM_IN_BYTES'               ,'Cumulated'
                       ,'VM_OUT_BYTES'              ,'Cumulated'
                       ,'TCP_SEND_SIZE_MIN'         ,'Current'
                       ,'TCP_SEND_SIZE_DEFAULT'     ,'Constant'
                       ,'TCP_SEND_SIZE_MAX'         ,'Current'
                       ,'TCP_RECEIVE_SIZE_MIN'      ,'Current'
                       ,'TCP_RECEIVE_SIZE_DEFAULT'  ,'Constant'
                       ,'TCP_RECEIVE_SIZE_MAX'      ,'Current'
                       ,'GLOBAL_SEND_SIZE_MAX'      ,'Current'
                       ,'GLOBAL_RECEIVE_SIZE_MAX'   ,'Current'
                       ,'?') as type
     , decode(comments --,'Number of active CPUs'
                       ,'Time (centi-secs) that CPUs have been in the idle state'        ,'Time that CPUs have been in the idle state'
                       ,'Time (centi-secs) that CPUs have been in the busy state'        ,'Time that CPUs have been in the busy state'
                       ,'Time (centi-secs) spent in user code'                           ,'Time spent in user code'
                       ,'Time (centi-secs) spent in the kernel'                          ,'Time spent in the kernel'
                       ,'Time (centi-secs) spent waiting for IO'                         ,'Time spent waiting for IO'
                       ,'Time (centi-secs) spend in low-priority user code'              ,'Time spend in low-priority user code'
                       ,'Time (centi-secs) processes spent in the runnable state waiting','Time processes spent in the runnable state waiting'
                     --,'Number of processes running or waiting on the run queue'
                     --,'Number of CPU cores'
                     --,'Number of physical CPU sockets'
                       ,'Physical memory size in bytes','Physical memory size'           ,'Paged in due to virtual memory swapping'
                       ,'Bytes paged in due to virtual memory swapping'                  ,'Paged out due to virtual memory swapping'
                       ,'Bytes paged out due to virtual memory swapping'
                     --,'TCP Send Buffer Min Size'
                     --,'TCP Send Buffer Default Size'
                     --,'TCP Send Buffer Max Size'
                     --,'TCP Receive Buffer Min Size'
                     --,'TCP Receive Buffer Default Size'
                     --,'TCP Receive Buffer Max Size'
                     --,'Global send size max (net.core.wmem_max)'
                     --,'Global receive size max (net.core.rmem_max)'
                       ,comments) as comments
  from v$osstat
 where 1=1
 --and stat_name LIKE '%MEMORY_BYTES'
 order by stat_ord
;

---------
-- EOF --
---------
