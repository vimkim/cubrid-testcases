drop table if exists t;
create table t (a string, b string);
insert into t values ('c',null);
create index idx2 on t(nvl(a,b)) invisible;
update statistics on t;
show index from t;
commit;
update t set a = null;
select * from t; 
drop table t;
