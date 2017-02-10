use hr;

# p56-2

# (한번이라도) 직무 변경, 부서 전배한 사원의 목록

select * from job_history;

## in: SIMPLE

-- explain
select * 
from employees
where employee_id in (select employee_id from job_history)
;

## exists: DEPENDENT SUBQUERY: Correlated

-- explain
select * 
from employees e
where exists (select 'x' 
				from job_history 
				where employee_id = e.employee_id) -- 'x' means?
;

# 부서별 월별 평균급여

## bad

-- explain
select department_id, month(hire_date), avg(salary)
from employees
group by department_id, month(hire_date) -- month()
order by 1, 2
;

## good

-- explain
select last_name
	, department_id
	, if(month(hire_date)=1, salary, null) m01
	, if(month(hire_date)=2, salary, null) m02
	, if(month(hire_date)=3, salary, null) m03
	, if(month(hire_date)=4, salary, null) m04
	, if(month(hire_date)=5, salary, null) m05
	, if(month(hire_date)=6, salary, null) m06
	, if(month(hire_date)=7, salary, null) m07
	, if(month(hire_date)=8, salary, null) m08
	, if(month(hire_date)=9, salary, null) m09
	, if(month(hire_date)=10, salary, null) m10
	, if(month(hire_date)=11, salary, null) m11
	, if(month(hire_date)=12, salary, null) m12
    , salary
from employees
;

## refac

-- explain
select last_name
	, department_id
	, if(month(hire_date)=1, salary, null) m01
	, if(month(hire_date)=2, salary, null) m02
	, if(month(hire_date)=3, salary, null) m03
	, if(month(hire_date)=4, salary, null) m04
	, if(month(hire_date)=5, salary, null) m05
	, if(month(hire_date)=6, salary, null) m06
	, if(month(hire_date)=7, salary, null) m07
	, if(month(hire_date)=8, salary, null) m08
	, if(month(hire_date)=9, salary, null) m09
	, if(month(hire_date)=10, salary, null) m10
	, if(month(hire_date)=11, salary, null) m11
	, if(month(hire_date)=12, salary, null) m12
    , salary
from employees
;

## avg

-- explain
select department_id
	, avg(if(hire_month=1, salary, null)) m01
	, avg(if(hire_month=2, salary, null)) m02
	, avg(if(hire_month=3, salary, null)) m03
	, avg(if(hire_month=4, salary, null)) m04
	, avg(if(hire_month=5, salary, null)) m05
	, avg(if(hire_month=6, salary, null)) m06
	, avg(if(hire_month=7, salary, null)) m07
	, avg(if(hire_month=8, salary, null)) m08
	, avg(if(hire_month=9, salary, null)) m09
	, avg(if(hire_month=10, salary, null)) m10
	, avg(if(hire_month=11, salary, null)) m11
	, avg(if(hire_month=12, salary, null)) m12
from (select department_id, salary, month(hire_date) hire_month 
		from employees) da
group by department_id
order by department_id
;

# p57-2

# cube example

select *
from employees
;

## 부서별 / 직무별

-- explain
select department_id, job_id, count(*) 직원수, sum(salary) 급여총액
from employees
group by department_id, job_id
order by isnull(department_id), department_id, isnull(job_id), job_id asc -- ref; http://stackoverflow.com/questions/2051602/mysql-orderby-a-number-nulls-last
;

## 부서별

-- explain
select department_id, NULL, count(*) 직원수, sum(salary) 급여총액
from employees
group by department_id
order by isnull(department_id), department_id asc -- ref; http://stackoverflow.com/questions/2051602/mysql-orderby-a-number-nulls-last
;

## 직무별
## ST_CLERK

-- explain
select NULL, job_id, count(*) 직원수, sum(salary) 급여총액
from employees
group by job_id
order by isnull(job_id), job_id asc -- ref; http://stackoverflow.com/questions/2051602/mysql-orderby-a-number-nulls-last
;

## 전체
## count 106 vs 107

-- explain
select NULL, NULL, count(*) 직원수, sum(salary) 급여총액
from employees
;

select * from employees;


--

-- explain 
select department_id, job_id, count(*) 직원수, sum(salary) 급여총액
from (
	select department_id, job_id, count(*) 직원수, sum(salary) 급여총액
	from employees
	group by department_id, job_id
	-- order by isnull(department_id), department_id, isnull(job_id), job_id asc
    
    union all
    
	select department_id, NULL, count(*) 직원수, sum(salary) 급여총액
	from employees
	group by department_id
	-- order by isnull(department_id), department_id
);


-- 
explain
(
select department_id, job_id, count(*) 직원수, sum(salary) 급여총액
from employees
group by department_id, job_id
order by isnull(department_id), isnull(job_id), department_id, job_id
)
union all
(
select department_id, NULL, count(*) 직원수, sum(salary) 급여총액
from employees
group by department_id
order by isnull(department_id), department_id
)
union all
(
select NULL, job_id, count(*) 직원수, sum(salary) 급여총액
from employees
group by job_id
order by isnull(job_id), job_id
)
union all
(
select NULL, NULL, count(*) 직원수, sum(salary) 급여총액
from employees
)
;

--

SELECT 
    *
FROM
    (SELECT 
        department_id, job_id, COUNT(*) member_cnt, SUM(salary)
    FROM
        employees
    GROUP BY department_id , job_id WITH ROLLUP) t
ORDER BY ISNULL(t.department_id) , ISNULL(t.job_id) , t.department_id , t.job_id;

--

-- explain
select *
from (
	(
	select department_id, job_id, count(*) 직원수, sum(salary) 급여총액
	from employees
	group by department_id, job_id
	order by isnull(department_id), isnull(job_id), department_id, job_id
	)
	union all
	(
	select department_id, NULL, count(*) 직원수, sum(salary) 급여총액
	from employees
	group by department_id
	order by isnull(department_id), department_id
	)
	union all
	(
	select NULL, job_id, count(*) 직원수, sum(salary) 급여총액
	from employees
	group by job_id
	order by isnull(job_id), job_id
	)
	union all
	(
	select NULL, NULL, count(*) 직원수, sum(salary) 급여총액
	from employees
	)
) t1
order by -1, -2;