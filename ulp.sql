col proxy for a30;
col client for a30;
col AUTHENTICATION for a10 heading AUTH_TYPE;
col FLAGS for a20;
select client,proxy,AUTHENTICATION from proxy_users
where client like upper('%&name%')
order by 1,2;

