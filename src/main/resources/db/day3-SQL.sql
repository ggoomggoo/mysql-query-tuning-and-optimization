use hr;

# CASE ~ WHEN ~ THEN

-- explain
select
	case 
		when salary <= 4000 then '초급'
		when salary <= 7000 then '중급'
		when salary <= 10000 then '고급'
        else '특급'
	end sal_grade,
    count(*) 직원수
from employees
group by
	case 
		when salary <= 4000 then '초급'
		when salary <= 7000 then '중급'
		when salary <= 10000 then '고급'
        else '특급'
	end
order by
	case sal_grade
		when '초급' then 1
		when '중급' then 2
		when '고급' then 3
        else 4
	end
;