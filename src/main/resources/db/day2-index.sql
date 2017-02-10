use hr;

##cluster화
create table my_prim(
	id varchar(10),
    name varchar(10)
);

#
insert into my_prim(id, name) values('3333', 'haha');
select * from my_prim;
insert into my_prim(id, name) values('1111', 'susu');
select * from my_prim;

#
alter table my_prim add primary key(id);
select * from my_prim; -- order 변경됨

#
alter table my_prim drop primary key;
alter table my_prim add primary key(name);
select * from my_prim; -- order 변경됨

#
delete from my_prim where id = '3333';
delete from my_prim where id = '1111';

#
explain
select * from employees
where salary between 8000 and 9000;

# id 100 or 200
explain
select * from employees
where salary between 8000 and 9000;

# range vs all scan type
explain
select *
from employees
-- where last_name like 'K%'
where first_name like 'K%'
-- 
;

# hint

# index - force
show index from employees;
explain
select *
from employees force index(last_name, salary); -- 

# index - Covering Index, add, ignore
alter table employees add index emp_last_first_salary_ix(last_name, first_name, salary); -- index naming convention: table + column ...
explain
select last_name, first_name, salary
from employees
-- ignore index(emp_last_first_salary_ix)
;

###

use myhr;
desc employee;

# prefix index
show index from employee;
alter table employee add index(last_name(4));
show index from employee;


# last_name Straney
explain
select *
from employee force index(last_name_2)
where last_name like 'Starney'
;

show index from emp_table;


# partial index
select title, count(*)
from emp_title
group by substring(title, 1, 4)
order by 2 desc
limit 4
;

### 

use hr;

# 
create table some_table (
	id varchar(10),
    sub_id varchar(8) as (substring(id, 1, 8)), -- 5.7~ // Like Oracle Function Based Index
    index(sub_id)
);

insert into some_table(id) values('sub_id_001');
select * from some_table;

# not use index

# use index
show index from employees;
explain
select * from employees
-- where salary * 12 >= 100000
-- where salary > (120000/12)
-- where substring(last_name, 1, 1) = 'K' -- 변형하면 인덱스 미사용
where last_name like 'K%' -- like 활용하여 인덱스 사용
;

# 날짜를 varchar로 관리하기도 한다
drop table my_internal;

create table my_internal (
	t_no varchar(10) primary key,
    t_name varchar(20)
);

insert into my_internal values(1234, 'haha');

explain
select *
from my_internal
where t_no = 1234 -- 컬럼 타입과 값 타입을 일치 시켜야 한다. 이 경우, 문자열을 정수로 형변환 작업을 거친다.
;

# index - and vs or
explain
select *
from employees
-- where last_name = 'King' and first_name = 'Steven'
where last_name = 'King' or first_name = 'Steven'
;

# 인덱스 사용여부 비교
drop table t_emp;

create table t_emp (
	id int,
    name varchar(200),
    hire_date varchar(8)
);

insert into t_emp(id, name, hire_date)
select employee_id, first_name, date_format(hire_date, '%Y%m%d')
from employees
;

select * from t_emp;

# add index
alter table t_emp add index (hire_date);

# vs
explain
select *
from t_emp
where hire_date = 19930113 -- all
-- where hire_date = '19930113' -- ref
;

# p31-2
-- use myhr;
select * from information_schema.STATISTICS
where TABLE_NAME = 'employees'
;

# 
optimize table employees;