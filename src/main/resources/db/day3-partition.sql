use hr;

# partition

create table members (
	first_name varchar(25) not null,
	last_name varchar(25) not null,
	user_name varchar(25) not null,
	email varchar(30) not null,
	joined date
);

-- add partition

alter table members
partition by range columns(joined)(
	partition plessthan1960 values less than ('1960-01-01'),
	partition p1970 values less than ('1970-01-01'),
	partition p1980 values less than ('1980-01-01'),
	partition p1990 values less than ('1990-01-01'),
	partition pmax values less than maxvalue
);

drop table members;
show create table members;

-- partition info

select *
from information_schema.PARTITIONS
where table_name = 'members'
;

# 파티션 실습하기
## Emp_salary테이블을 파티션으로 분할하려 한다.
## 테이블이름은 partitioned_emp_salary
## From_date에 저장된 값을 조사하여 년도별 파티션을 생성함.
## Emp_salary에 저장된 데이터를 저장함.
## 각 파티션에 저장된 Row수 등의 데이터의 현황을 조회하여 붙여넣기 함.
## 테이블의 파티션화된 결과를 캡쳐하여 붙여넣기 함.

use myhr;

select * from emp_salary;

select min(from_date), max(from_date) from emp_salary;

alter table emp_salary
partition by range columns(from_date)(
	partition plessthan1960 values less than ('1960-01-01'),
	partition p1970 values less than ('1970-01-01'),
	partition p1980 values less than ('1980-01-01'),
	partition p1990 values less than ('1990-01-01'),
	partition p2000 values less than ('2000-01-01'),
	partition pmax values less than maxvalue
);

select *
from information_schema.PARTITIONS
where table_name = 'emp_salary'
;