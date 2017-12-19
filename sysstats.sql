col sname for a30;
col pname for a30;
col pval1 for 9999999999;
col pval2 for a40; 
select sname,pname,pval1,pval2
from sys.aux_stats$
where sname = 'SYSSTATS_INFO'
order by 1,2;


col sname for a30;
col pname for a30;
col pval1 for 9999999999;
col pval2 for a40; 
select sname,pname,pval1,pval2
from sys.aux_stats$
where sname = 'SYSSTATS_MAIN'
order by 1,2;
