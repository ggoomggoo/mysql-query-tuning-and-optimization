use hr;

# 
explain
select *
from employees
where last_name = 'King'
	and first_name = 'Steven'
;

# scala subquery
explain
select *
from employees
where manager_id = (select employee_id
					from employees
					where last_name = 'King'
						and first_name = 'Steven')
;

# 사원정보를 부서평균급여와 함께 출력
# DEPENDENT SUBQUERY
explain
select *
	, (select avg(salary) from employees where e.department_id = department_id) -- 각 row에 대해서 계속 연산됨
from employees e;

# 
explain
select *
from employees e
	join (select avg(salary) dept_avg_salary, department_id from employees group by department_id) da using(department_id);

### 

use myhr; 

# 부서별 평균급여를 부서명과 함께 출력하시오.

-- 01
explain
select d.dept_no, d.dept_name
from department d
	join dept_emp de using(dept_no)
    join emp_salary es using(emp_no)
where de.to_date = '9999-01-01'
	and es.to_date = '9999-01-01'
group by d.dept_no
;

-- 02
explain
select d.dept_no, d.dept_name, avg_salary
from department d
	join (select dept_no, avg(salary) avg_salary
			from dept_emp de
				join emp_salary es
                using(emp_no)
			group by dept_no) da
    using(dept_no)
;

explain
select dept_no, avg(salary) avg_salary,
	(select dept_name from department where de.dept_no = dept_no) dept_name
from dept_emp de
	join emp_salary es
	using(emp_no)
group by dept_no
;

alter table dept_emp add primary key (emp_no);

desc dept_emp;