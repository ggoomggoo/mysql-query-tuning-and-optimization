# example join
use myhr;

explain
select straight_join t1.last_name
	, t1.first_name
    , t1.hire_date
    , t2.salary
from employee t1 
	left join emp_salary t2 on (t1.emp_no between 10004 and 100014 and t1.emp_no = t2.emp_no)
	left join dept_emp t3 on (t1.emp_no = t2.emp_no)
-- where t1.emp_no between 10004 and 100014
;

show index from employee;
alter table employee add index (emp_no);

select *
from emp_salary
;

select *
from dept_emp
;

select *
from department
;

explain
select count(*)
from emp_salary;

desc emp_salary;
desc emp_title;
desc dept_emp;
desc department;

show index from employee;
show index from emp_salary;
show index from emp_title;
show index from dept_emp;

alter table employee add index (emp_no);
alter table emp_salary add index (emp_no);
alter table emp_title add index (emp_no);
alter table dept_emp add index (emp_no);
alter table dept_emp add index (dept_no);