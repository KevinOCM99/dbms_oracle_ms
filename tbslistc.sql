
set linesize 150 pagesize 100 heading on feedback 1 verify off
column segment_space_management format a1     heading "S|M"
--"SEGMENT|Mgmt"
column extent_management        format a1     heading "E|M"
--"EXTENT|Mgmt"
column allocation_type          format a1     heading "A|T"
--"ALLOCATION|Type"
column contents                 format a1     heading "C|o"
--"TABLESPACE|Contents"
column tablespace_name          format a18     heading "TABLESPACE|Name"
column dbf_count                format 99      heading "DBF|Cnt"
column usage_proportion         format a10     heading "USAGE|Proportion"
column usage_percentage         format a07     heading "  USAGE|    Pct"
column            tbs_size_mb   format 99999999 heading "ALLOCATED|All(MB)"
column       used_tbs_size_mb   format 99999999 heading "ALLOCATED|Used(MB)"
column       free_tbs_size_mb   format 99999999 heading "ALLOCATED|Free(MB)"
column extensible               format a1       heading "E|x"
--"EXT|?"
column extensible_tbs_size_mb   format 999999999 heading "EXT|Left(MB)"
column   real_max_tbs_size_mb   format 999999999 heading "+EXT|All(MB)"
column   max_free_tbs_size_mb   format 999999999 heading "+EXT|Free(MB)"
column status                   format a7
column logging                  format a9
column plugged_in               format a10
column CON_NAME                 format a10
accept ts_name prompt "Tablepspace Name(default:all)? "
with
data as (
select d.extent_management
     , d.allocation_type
     , d.contents
     , d.tablespace_name
     , nvl(         u.tbs_bytes,0) as          tbs_size
     , nvl(     u.max_tbs_bytes,0) as      max_tbs_size
     , nvl(u.real_max_tbs_bytes,0) as real_max_tbs_size
     , nvl(    f.free_tbs_bytes,0) as     free_tbs_size
     , u.dbf_count
     , d.status
     , d.logging
     , d.plugged_in
     , d.segment_space_management
     , d.con_id
  from cdb_tablespaces d
     , (select con_id,tablespace_name
             , count(1)                                         as dbf_count
             , sum(bytes)                                       as          tbs_bytes
             , sum(maxbytes)                                    as      max_tbs_bytes
             , sum(decode(autoextensible,'YES',maxbytes,bytes)) as real_max_tbs_bytes
          from cdb_data_files
         group by con_id,tablespace_name) u
     , (select con_id,tablespace_name
             , sum(bytes)                                       as     free_tbs_bytes
          from cdb_free_space
         group by con_id,tablespace_name) f
where (d.extent_management<>'LOCAL' or d.contents<>'TEMPORARY')
  and d.tablespace_name = u.tablespace_name(+)
  and d.tablespace_name = f.tablespace_name(+)
  and d.con_id = u.con_id(+)
  and d.con_id = f.con_id(+)
),
temp as (
select d.extent_management
     , d.allocation_type
     , d.contents
     , d.tablespace_name
     , nvl(u.bytes, 0)
     , nvl(u.maxbytes, 0)
     , nvl(u.realmaxbytes, 0) as real_max_ts_size
     , nvl(u.bytes, 0) - nvl(f.bytes, 0)
     , u.dbf_count
     , d.status
     , d.logging
     , d.plugged_in
     , d.segment_space_management
     , d.con_id
  from cdb_tablespaces d
     , (select con_id,tablespace_name
             , count(1) dbf_count
             , sum(bytes) bytes
             , sum(maxbytes) maxbytes
             , sum(decode(autoextensible,'YES', maxbytes, bytes)) realmaxbytes
          from cdb_temp_files
         group by con_id,tablespace_name) u,
       (select con_id,tablespace_name
             , sum(bytes_cached) bytes
          from v$temp_extent_pool
         group by con_id,tablespace_name) f
 where d.extent_management='LOCAL'
   and d.contents='TEMPORARY'
   and d.tablespace_name = u.tablespace_name(+)
   and d.tablespace_name = f.tablespace_name(+)
   and d.con_id = u.con_id(+)
   and d.con_id = f.con_id(+)   
),
all_tbs1 as (select * from data union all select * from temp),
cdb_tbs as (select a.*,b.name CON_NAME from all_tbs1 a, v$containers b where a.con_id = b.con_id)
select substr(segment_space_management,1,1) segment_space_management
     , substr(decode(extent_management,'DICTIONARY','Dict',extent_management),1,1) as extent_management
     , substr(allocation_type,1,1) allocation_type
     , substr(contents,1,1) contents
     , tablespace_name
     , nvl(rpad(rpad(rpad('*',decode(sign(1-10*((tbs_size-free_tbs_size)/nullif(real_max_tbs_size,0))),1,1
                         ,10*((tbs_size-free_tbs_size)/nullif(real_max_tbs_size,0))),'*')
                    ,decode(sign(1-10*(tbs_size/nullif(real_max_tbs_size,0))),1,1
                    ,10*(tbs_size/nullif(real_max_tbs_size,0))),'+')
               ,10,'-'),null)                                        as usage_proportion
     , lpad(ltrim(to_char(round((tbs_size-free_tbs_size)/nullif(real_max_tbs_size,0)*100,2),'999.00')||'%'),7,' ') as usage_percentage
     , dbf_count
     , round(tbs_size/1024/1024)                                     as            tbs_size_mb
     , round((tbs_size-free_tbs_size)/1024/1024)                     as       used_tbs_size_mb
     , round(free_tbs_size/1024/1024)                                as       free_tbs_size_mb
--     , decode(sign(real_max_tbs_size-tbs_size),0,'NO',1,'YES','?')   as extensible
     , decode(sign(real_max_tbs_size-tbs_size),0,'N',1,'Y','?')   as extensible
     , round((real_max_tbs_size-tbs_size)/1024/1024)                 as extensible_tbs_size_mb
     , round(real_max_tbs_size/1024/1024)                            as   real_max_tbs_size_mb
     , round((real_max_tbs_size-(tbs_size-free_tbs_size))/1024/1024) as   max_free_tbs_size_mb
   --, status
   --, logging
   --, plugged_in
     , CON_NAME
  from cdb_tbs
 where lower(tablespace_name) like decode(lower('&ts_name'),'','%','all','%',lower('&ts_name'))
 order by con_id,contents,tablespace_name--usage_percentage desc
/    
