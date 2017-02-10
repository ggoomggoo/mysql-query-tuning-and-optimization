use hr;

# lock - table

create table my_t (
	id int auto_increment primary key,
    name varchar(10)
)engine=MyISAM; -- default innoDB

insert into my_t(name) values('haha');

select * from my_t;

update my_t set name=sleep(200) where id=1; -- sleep()

select * from my_t; -- locked state

-- $ show processlist;

# lock - row

create table my_inno_t (
	id int auto_increment primary key,
    name varchar(10)
);

insert into my_inno_t(name) values('haha');
insert into my_inno_t(name) values('kaka');
insert into my_inno_t(name) values('lala');

select * from my_inno_t;

update my_inno_t set name=sleep(200) where id=1;

select * from my_inno_t; -- ok

# ...

# ...
show variables like 'innodb_lock%';
select @@autocommit; -- 1: is autocommit

# tranaction

begin;
update my_inno_t set name='pupu' where id = 1;
select *  from my_inno_t;
commit;
end;

-- show engine innodb status;

begin;
insert into my_inno_t values ('deadlock');
select *  from my_inno_t;